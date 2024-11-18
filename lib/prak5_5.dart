import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Pserta Sidang',
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
  List orang2 = [];
 
  // Fetch content from the json file
  Future<void> readJson() async {
    final String ygDibaca =
        await rootBundle.loadString('jsonfolder/contoh.json.txt');
    final dataOrang = await json.decode(ygDibaca);
    setState(() {
      orang2 = dataOrang["orang"];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Peserta Sidang TA',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: readJson,
              child: const Text('Ambil Data'),
            ),
            // Display the data loaded from sample.json
            orang2.isNotEmpty?
                Expanded(
                    child: ListView.builder(
                      itemCount: orang2.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Text(orang2[index]["id"]),
                            title: Text(orang2[index]["name"]),
                            subtitle: Text(orang2[index]["description"]),
                          ),
                        );
                      },
                    ),
                  ) :
                Container()
          ],
        ),
      ),
    );
  }
}
