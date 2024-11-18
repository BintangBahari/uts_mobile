// Import paket-paket yang diperlukan
import 'package:flutter/material.dart'; // Untuk membuat UI dengan Material Design
import 'package:flutter/services.dart' show rootBundle; // Untuk membaca file dari folder aset aplikasi
import 'package:csv/csv.dart'; // Untuk mengonversi file CSV menjadi List

// Fungsi utama aplikasi Flutter
void main() {
  runApp(const MyApp()); // Menjalankan aplikasi dengan widget utama `MyApp`
}

// Widget utama aplikasi (stateless)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Konstruktor

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: 'Praktikum55', // Judul aplikasi
      home: HomePage(), // Halaman utama aplikasi
    );
  }
}

// Halaman utama aplikasi (stateful widget)
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Konstruktor

  @override
  HomePageState createState() => HomePageState(); // Menghubungkan dengan state
}

// State dari halaman utama
class HomePageState extends State<HomePage> {
  List<List<dynamic>> _data = []; // Variabel untuk menyimpan data CSV

  // Fungsi untuk membaca dan memproses file CSV
  void _loadCSV() async {
    // Membaca file CSV dari folder aset
    final rawData = await rootBundle.loadString("csvfolder/user.csv");

    // Mengonversi data CSV menjadi List<List<dynamic>>
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    // Memperbarui state dengan data yang telah diolah
    setState(() {
      _data = listData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Praktukum55"), // Judul aplikasi di AppBar
      ),
      body: ListView.builder(
        itemCount: _data.length, // Jumlah item sesuai jumlah baris data CSV
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.all(3), // Margin untuk setiap kartu
            color: index == 0 ? Colors.amber : Colors.white, // Warna berbeda untuk header
            child: ListTile(
              leading: Text(_data[index][0].toString()), // Data kolom pertama
              title: Text(_data[index][1]), // Data kolom kedua
              trailing: Text(_data[index][2].toString()), // Data kolom ketiga
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCSV, // Memanggil fungsi `_loadCSV` saat tombol ditekan
        child: const Icon(Icons.add), // Ikon tombol
      ),
    );
  }
}
