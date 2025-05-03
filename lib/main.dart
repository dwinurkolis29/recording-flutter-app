import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/chicken_data.dart';

import 'main_app.dart';
void main() async {
  await Hive.initFlutter();
  /// Initialize Hive
  await _initHive();
  Hive.registerAdapter(ChickenDataAdapter()); // Register the adapter
  await Hive.openBox<ChickenData>('chickenData'); // Open the box
  /// Run the application
  runApp(const MainApp());
}

Future<void> _initHive() async{
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}
