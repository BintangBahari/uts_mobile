import 'package:flutter/material.dart';
import 'package:prak5/input.dart';
import 'package:prak5/home.dart';
import 'package:prak5/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Beranda(), // Menjadikan Home sebagai halaman awal
      routes: {
        "beranda": (context) => const Beranda(),
        "signup": (context) => const SignupPage(),
      },
    );
  }
}
