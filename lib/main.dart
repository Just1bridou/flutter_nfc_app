import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/camera.dart';
import 'package:flutter_nfc/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter NFC App',
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: Colors.black87))),
      home: HomePage(),
    );
  }
}
