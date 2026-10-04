import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// --- MODELS ---
class AppUser {
  final String uid;
  final String name;

  AppUser({required this.uid, required this.name});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
    );
  }
}

// --- SERVICES ---
class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users from the 'sixside' document field 'sixsideusers'
  Stream<List<AppUser>> getSixSideUsers() {
    return _firestore.collection('sixside').doc('main').snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return [];
      
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> usersList = data['sixsideusers'] ?? [];
      
      return usersList.map((userMap) => AppUser.fromMap(userMap as Map<String, dynamic>)).toList();
    });
  }

  // Send a game request
  Future<void> sendGameRequest({
    required String fromUid,
    required String toUid,
  }) async {
    final docRef = _firestore.collection('sixsiderequests').doc();
    await docRef.set({
      'id': docRef.id,
      'from': fromUid,
      'to': toUid,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Accept a game request
  Future<void> acceptGameRequest(String requestId) async {
    await _firestore.collection('sixsiderequests').doc(requestId).update({
      'status': 'accepted',
    });
  }
}

// --- SCREENS ---

// 1. User Search & Request Screen (User A's View)
class UserSearchScreen extends StatefulWidget {
  final String currentUserId; // Current logged-in user (User A)

  UserSearchScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final GameService _gameService = GameService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Pops the current route off the stack
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(title: const Text('Find Players - SixSide')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name (starts with)...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          
          // User List Stream
          Expanded(
            child: StreamBuilder<List<AppUser>>(
              stream: _gameService.getSixSideUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final users = snapshot.data ?? [];

                // Filter users: Exclude self & filter by name starting with query
                final filteredUsers = users.where((user) {
                  if (user.uid == widget.currentUserId) return false; // Don't show self
                  if (_searchQuery.isEmpty) return true;
                  return user.name.toLowerCase().startsWith(_searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return  Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(user.name[0].toUpperCase())),
                      title: Text(user.name),
                      trailing: ElevatedButton(
                        child: Text('Send Request'),
                        onPressed: () => _showRequestDialog(context, user),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper to configure and send the game request details
  void _showRequestDialog(BuildContext context, AppUser targetUser) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Send Game Request to ${targetUser.name}'),
          content: const Text('Do you want to send a match request?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Send'),
              onPressed: () async {
                await _gameService.sendGameRequest(
                  fromUid: widget.currentUserId,
                  toUid: targetUser.uid,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request sent to ${targetUser.name}!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// 2. Incoming Requests Screen (User B's View)
class IncomingRequestsScreen extends StatelessWidget {
  final String currentUserId; // Current logged-in user (User B)

  IncomingRequestsScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameService gameService = GameService();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Pops the current route off the stack
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(title: const Text('Incoming Game Requests')),
      body: StreamBuilder<QuerySnapshot>(
        // Listen to pending requests where 'to' matches current user
        stream: FirebaseFirestore.instance
            .collection('sixsiderequests')
            .where('to', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending game requests.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index].data() as Map<String, dynamic>;
              final requestId = req['id'];
              final fromUser = req['from'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('From: $fromUser'),
                  subtitle: Text('Simple accept message'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Accept', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await gameService.acceptGameRequest(requestId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Game Request Accepted!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
