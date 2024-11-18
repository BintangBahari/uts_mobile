// Import paket Flutter dan utilitas yang diperlukan
import 'package:flutter/material.dart'; // Untuk membuat UI dengan Material Design
import 'package:flutter/services.dart' show rootBundle; // Untuk mengakses file dari folder aset aplikasi
import 'dart:async'; // Untuk mendukung pemrograman asinkron dengan Future dan async/await

// Fungsi utama aplikasi Flutter
void main() {
  runApp(const MyApp()); // Menjalankan widget utama aplikasi
}

// Widget utama aplikasi (stateless)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Konstruktor

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: 'CobaBacaTXT_dariAsset', // Judul aplikasi
      home: HomePage(), // Halaman utama aplikasi
    );
  }
}

// Halaman utama aplikasi (stateful widget)
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Konstruktor

  @override
  _HomePageState createState() => _HomePageState(); // Menghubungkan dengan state
}

// State dari halaman utama
class _HomePageState extends State<HomePage> {
  String _data = ''; // Variabel untuk menyimpan data yang dibaca dari file

  // Fungsi asinkron untuk membaca file dari folder aset
  Future<void> _loadData() async {
    final dataygdibaca = await rootBundle.loadString('assets/data.txt'); 
    // Membaca isi file 'data.txt' dari folder 'assets'
    setState(() {
      _data = dataygdibaca; // Memperbarui state dengan data yang dibaca
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CobaBacaTXT_dariAsset'), // Judul di AppBar
      ),
      body: Center(
        child: SizedBox(
          width: 300, // Lebar maksimal untuk teks
          child: Text(
            _data.isNotEmpty ? _data : 'Nothing to show', // Menampilkan data atau teks default
            style: const TextStyle(fontSize: 24), // Gaya teks
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData, // Fungsi dipanggil saat tombol ditekan
        child: const Icon(Icons.add), // Ikon untuk tombol
      ),
    );
  }
}
