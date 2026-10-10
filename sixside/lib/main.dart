import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'firebase_options.dart';

import 'package:uuid/uuid.dart';
// TODO(codelab user): Get API key
final String clientId = const Uuid().v4();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(
	options: DefaultFirebaseOptions.currentPlatform,
	);
  }catch (e){
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized.');
    } else {
      rethrow; // Rethrow if it's a completely different error
    }
  }
  runApp( MyApp(clientId: clientId));
}
