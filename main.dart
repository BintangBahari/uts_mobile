import 'package:flutter/material.dart';
import 'sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Harga Barang',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _barang = [];
  bool _isLoading = true;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshDaftarBarang(); // Load data saat aplikasi mulai
  }

  Future<void> _refreshDaftarBarang() async {
    try {
      final data = await SQLHelper.getItems();
      setState(() {
        _barang = data;
        _isLoading = false;
      });
    } catch (err) {
      debugPrint("Error fetching data: $err");
    }
  }

  Future<void> _addItem() async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    await SQLHelper.createItem(
      _namaController.text,
      _hargaController.text,
    );
    _clearTextFields();
    _refreshDaftarBarang();
  }

  Future<void> _updateItem(int id) async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    await SQLHelper.updateItem(
      id,
      _namaController.text,
      _hargaController.text,
    );
    _clearTextFields();
    _refreshDaftarBarang();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang berhasil dihapus!')),
    );
    _refreshDaftarBarang();
  }

  void _clearTextFields() {
    _namaController.text = '';
    _hargaController.text = '';
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingBarang =
          _barang.firstWhere((element) => element['id'] == id);
      _namaController.text = existingBarang['nama'];
      _hargaController.text = existingBarang['harga'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga Barang'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                } else {
                  await _updateItem(id);
                }
                Navigator.of(context).pop(); // Tutup form
              },
              child: Text(id == null ? 'Tambah' : 'Perbarui'),
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
        title: const Text('Daftar Harga Barang'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _barang.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_barang[index]['nama']),
                  subtitle: Text(_barang[index]['harga']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showForm(_barang[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(_barang[index]['id']),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
