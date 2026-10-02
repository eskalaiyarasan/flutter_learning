import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'firebase_options.dart';

import 'package:uuid/uuid.dart';
// TODO(codelab user): Get API key
final String clientId = const Uuid().v4();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp(clientId: clientId));
}
