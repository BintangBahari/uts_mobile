import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CobaBacaTXT_dariAsset',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _data='';

  // This function is triggered when the user presses the floating button
  Future<void> _loadData() async {
    final dataygdibaca = await rootBundle.loadString('assets/data.txt');
    setState(() {
      _data = dataygdibaca;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CobaBacaTXT_dariAsset'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Text(_data ?? 'Nothing to show',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
      floatingActionButton: 
      FloatingActionButton( onPressed: _loadData, child: const Icon(Icons.add)),
    );
  }
}
