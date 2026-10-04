import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sixside.dart';
import 'game_service.dart';
class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(title: const Text('User Profile')),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      }),
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset('flutterfire_300x.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
// Button 1: Navigates to a StatefulWidget page
            TextButton(
              onPressed: () {
  		String uid = FirebaseAuth.instance.currentUser!.uid;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSearchScreen(currentUserId: uid)),
                );
              },
              child: const Text('1. SearchFirends'),
            ),
            const SizedBox(height: 16),
            
            // Button 2: Navigates to a StatelessWidget page
            TextButton(
              onPressed: () {
  		String uid = FirebaseAuth.instance.currentUser!.uid;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IncomingRequestsScreen(currentUserId: uid)),
                );
              },
              child: const Text('2. Go to incoming request'),
            ),
            const SizedBox(height: 16),
            
            // Button 3: Navigates to another StatelessWidget page
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainApp()),
                );
              },
              child: const Text('3. Go to the game'),
            ),
          ],
        ),
      ),
    );
  }
}
