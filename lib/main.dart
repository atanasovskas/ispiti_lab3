import 'package:flutter/material.dart';
import 'widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "xxx",
      appId: "xxx",
      messagingSenderId: "xxx",
      projectId: "xxx",
    ),
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key ? key}) :super( key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      theme: ThemeData(
        primarySwatch:  Colors.lightBlue
      ),
      home: const WidgetTree(),
    );
  }
}

