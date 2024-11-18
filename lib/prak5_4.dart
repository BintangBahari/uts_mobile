import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum53',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}
class HomePageState extends State<HomePage> {
  String _content = '';

  // Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // This function is triggered when the "Read" button is pressed
  Future<void> _readData() async {
    final dirPath = await _getDirPath();
    final myFile = File('$dirPath/data.txt');
    final data = await myFile.readAsString(encoding: utf8);

    setState(() {
      _content = data;
    });
  }

  // TextField controller
  final _textController = TextEditingController();

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData() async {
    final dirPath = await _getDirPath();
    final myFile = File('$dirPath/data.txt');
    // If data.txt doesn't exist, it will be created automatically

    await myFile.writeAsString(_textController.text);
    _textController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum53'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Enter your name'),
            ),
            ElevatedButton(
              onPressed: _writeData,
              child: const Text('Save to file'),
            ),
            const SizedBox(
              height: 150,
            ),
            Text(
                _content,
                style: const TextStyle(fontSize: 24, color: Colors.pink)),
            ElevatedButton(
              onPressed: _readData,
              child: const Text('Read my name from the file'),
            )
          ],
        ),
      ),
    );
  }
}