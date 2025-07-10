import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi Hive
  await Hive.initFlutter();
  
  // Inisialisasi Hive boxes
  await _initHive();

  runApp(const MainApp());
}

Future<void> _initHive() async {
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}
