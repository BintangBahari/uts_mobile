import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
void main() {
  runApp(MaterialApp(
    title: 'Passing Parameter',
    theme: ThemeData(primarySwatch: Colors.blue),
    home : const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map<String, dynamic> fromAbout = {
    "param0": " ",
    "param1": " ",
    "param2": " ",
  };

  Map<String, dynamic> toAbout = {
    "data0": "ini",
    "data1": "dari",
    "data2": "home",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Home'),
      ),
      body: Center(
        child : Column(
            children: <Widget> [
              Text(fromAbout['param0']),
              Text(fromAbout['param1']),
              Text(fromAbout['param2']),
              ElevatedButton(
                child: const Text('Ke halaman about'),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const About(),
                      settings: RouteSettings(
                        arguments: toAbout,
                      ),
                    ),
                  );
                  setState(() {
                    fromAbout = result;
                  });
                },
              ),]
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> fromAbout = { // akan dikirim ke home
      "param0": "fromAbout01",
      "param1": "fromAbout02",
      "param2": "fromAbout03",
    };

    late Map<String, dynamic> fromHome; // declare var terima dari home
    fromHome = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Halaman About')),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(fromHome["data0"]),
            Text(fromHome["data1"]),
            Text(fromHome["data2"]),
            ElevatedButton(
                child: const Text('Kembali ke Home'),
                onPressed: () {
                  Navigator.pop(context,fromAbout,);
                }
            ),
          ],
        ),
      ),
    );
  }
}
