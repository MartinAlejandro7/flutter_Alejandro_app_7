import 'package:flutter/material.dart';
import 'package:flutter_application_7/pantallas/login_page.dart';

void main() {
  runApp(const MyApp());
}

/// Aplicación principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Login',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
