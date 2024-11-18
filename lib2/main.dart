import 'package:flutter/material.dart';
import 'sql_helper.dart';

void main() {
  runApp(const MyApp()); // Fungsi utama menjalankan aplikasi
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: 'Daftar Harga Laptop', // Judul aplikasi
      theme: ThemeData(
        primaryColor: Colors.yellow, // Warna utama untuk tema
        scaffoldBackgroundColor: Colors.green[200], // Warna latar belakang
      ),
      home: const HomePage(), // Halaman utama aplikasi
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState(); // Membuat state untuk widget
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _barang = []; // Data barang dari database
  bool _isLoading = true; // Status loading saat data sedang dimuat

  // Controller untuk input form
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshDaftarBarang(); // Ambil data dari database saat aplikasi mulai
  }

  // Fungsi untuk mengambil data dari database
  Future<void> _refreshDaftarBarang() async {
    try {
      final data = await SQLHelper.getItems(); // Ambil data dari SQLite
      setState(() {
        _barang = data; // Simpan data ke dalam variabel
        _isLoading = false; // Sembunyikan indikator loading
      });
    } catch (err) {
      debugPrint("Error fetching data: $err"); // Debug jika ada error
    }
  }

  // Fungsi untuk menambahkan data ke database
  Future<void> _addItem() async {
    if (_namaController.text.isEmpty) { // Validasi input nama tidak boleh kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    await SQLHelper.createItem(
      _namaController.text, // Nama barang
      _hargaController.text, // Harga barang
    );
    _clearTextFields(); // Kosongkan input setelah data ditambahkan
    _refreshDaftarBarang(); // Perbarui tampilan daftar
  }

  // Fungsi untuk memperbarui data barang
  Future<void> _updateItem(int id) async {
    if (_namaController.text.isEmpty) { // Validasi input nama
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    await SQLHelper.updateItem(
      id, // ID barang
      _namaController.text, // Nama baru
      _hargaController.text, // Harga baru
    );
    _clearTextFields(); // Kosongkan input setelah data diperbarui
    _refreshDaftarBarang(); // Perbarui daftar
  }

  // Fungsi untuk menghapus data barang
  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id); // Hapus data berdasarkan ID
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang berhasil dihapus!')),
    );
    _refreshDaftarBarang(); // Perbarui tampilan daftar
  }

  // Kosongkan input pada TextField
  void _clearTextFields() {
    _namaController.text = '';
    _hargaController.text = '';
  }

  // Menampilkan form untuk tambah/perbarui data
  void _showForm(int? id) {
    if (id != null) { // Jika ID diberikan, berarti update data
      final existingBarang =
          _barang.firstWhere((element) => element['id'] == id); // Ambil data berdasarkan ID
      _namaController.text = existingBarang['nama']; // Isi TextField nama
      _hargaController.text = existingBarang['harga']; // Isi TextField harga
    }

    showModalBottomSheet(
      context: context,
      elevation: 5, // Tinggi elevasi modal
      isScrollControlled: true, // Agar modal bisa digeser
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120, // Penyesuaian untuk keyboard
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Sesuaikan ukuran dengan konten
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _namaController, // Controller untuk nama
              decoration: const InputDecoration(labelText: 'Merk Laptop'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hargaController, // Controller untuk harga
              decoration: const InputDecoration(labelText: 'Harga Laptop'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) { // Jika ID null, tambahkan data baru
                  await _addItem();
                } else { // Jika ID ada, perbarui data
                  await _updateItem(id);
                }
                Navigator.of(context).pop(); // Tutup modal form
              },
              child: Text(id == null ? 'Tambah' : 'Perbarui'), // Judul tombol
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Harga Laptop'), // Judul pada AppBar
        backgroundColor: Theme.of(context).primaryColor, // Warna sesuai tema
      ),
      body: _isLoading // Tampilkan loading saat data belum dimuat
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _barang.length, // Jumlah item pada list
              itemBuilder: (context, index) => Card(
                color: Colors.green[100], // Warna kartu
                margin: const EdgeInsets.all(15), // Margin antar kartu
                child: ListTile(
                  title: Text(
                    _barang[index]['nama'], // Nama barang
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Harga: ${_barang[index]['harga']}'), // Harga barang
                  trailing: SizedBox(
                    width: 100, // Lebar untuk ikon aksi
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue), // Tombol edit
                          onPressed: () => _showForm(_barang[index]['id']), // Buka form update
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Tombol hapus
                          onPressed: () => _deleteItem(_barang[index]['id']), // Hapus data
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor, // Warna sesuai tema
        child: const Icon(Icons.add), // Tombol tambah
        onPressed: () => _showForm(null), // Buka form tambah
      ),
    );
  }
}
