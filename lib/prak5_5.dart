// Import paket-paket yang diperlukan
import 'package:flutter/material.dart'; // Untuk membuat UI dengan Material Design
import 'dart:convert'; // Untuk mengkonversi data JSON menjadi tipe Dart
import 'package:flutter/services.dart'; // Untuk membaca file dari folder aset aplikasi

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
      title: 'Pserta Sidang', // Judul aplikasi
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
  List orang2 = []; // Variabel untuk menyimpan daftar data orang

  // Fungsi asinkron untuk membaca file JSON dari folder aset
  Future<void> readJson() async {
    final String ygDibaca =
        await rootBundle.loadString('jsonfolder/contoh.json.txt'); 
    // Membaca file JSON dari folder 'jsonfolder' dalam aset aplikasi
    final dataOrang = await json.decode(ygDibaca); 
    // Mengonversi string JSON menjadi struktur data Dart (Map/List)
    setState(() {
      orang2 = dataOrang["orang"]; 
      // Menyimpan data orang ke dalam variabel `orang2` (list)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Judul di tengah
        title: const Text('Peserta Sidang TA'), // Judul aplikasi di AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(25), // Margin di sekitar konten
        child: Column(
          children: [
            ElevatedButton(
              onPressed: readJson, // Fungsi dipanggil saat tombol ditekan
              child: const Text('Ambil Data'), // Teks pada tombol
            ),
            // Menampilkan data jika sudah dimuat
            orang2.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: orang2.length, // Jumlah item yang ditampilkan
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10), // Margin untuk setiap kartu
                          child: ListTile(
                            leading: Text(orang2[index]["id"]), // Menampilkan ID
                            title: Text(orang2[index]["name"]), // Menampilkan nama
                            subtitle: Text(orang2[index]["description"]), // Menampilkan deskripsi
                          ),
                        );
                      },
                    ),
                  )
                : Container() // Jika data kosong, tampilkan `Container` kosong
          ],
        ),
      ),
    );
  }
}
