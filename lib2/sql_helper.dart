import 'package:flutter/foundation.dart'; // Digunakan untuk debugPrint, membantu debugging
import 'package:sqflite/sqflite.dart' as sql; // Menggunakan package sqflite untuk manipulasi database SQLite

class SQLHelper {
  // Membuat tabel barang di dalam database
  static Future<void> createTables(sql.Database database) async {
    try {
      await database.execute("""
      CREATE TABLE tabelbrg( // Nama tabel
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, // ID auto increment sebagai primary key
        nama TEXT NOT NULL, // Kolom nama, wajib diisi
        harga TEXT, // Kolom harga, boleh kosong
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP // Waktu dibuat, default waktu saat ini
      )
      """);
      debugPrint("Table 'tabelbrg' created successfully"); // Debug untuk memeriksa apakah tabel berhasil dibuat
    } catch (err) {
      debugPrint("Error creating table: $err"); // Debug jika terjadi error
    }
  }

  // Membuka atau membuat database baru
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'hrgBrg.db', // Nama file database
      version: 1, // Versi database
      onCreate: (sql.Database database, int version) async {
        await createTables(database); // Membuat tabel jika database baru dibuat
      },
    );
  }

  // Menambahkan barang baru ke dalam tabel
  static Future<int> createItem(String nama, String? harga) async {
    try {
      final db = await SQLHelper.db(); // Membuka database

      // Validasi: nama tidak boleh kosong
      if (nama.isEmpty) throw Exception("Nama barang tidak boleh kosong");

      // Data barang yang akan disimpan
      final data = {'nama': nama, 'harga': harga};

      // Menyisipkan data ke tabel 'tabelbrg'
      final id = await db.insert(
        'tabelbrg', // Nama tabel
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace, // Mengganti data jika terjadi konflik
      );
      return id; // Mengembalikan ID barang yang ditambahkan
    } catch (err) {
      debugPrint("Error inserting item: $err"); // Debug jika terjadi error
      return -1; // Indikasi kesalahan
    }
  }

  // Membaca semua barang dari tabel
  static Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final db = await SQLHelper.db(); // Membuka database
      return db.query('tabelbrg', orderBy: "id"); // Mengambil semua data, diurutkan berdasarkan ID
    } catch (err) {
      debugPrint("Error fetching items: $err"); // Debug jika terjadi error
      return []; // Mengembalikan list kosong jika ada kesalahan
    }
  }

  // Membaca satu barang berdasarkan ID
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    try {
      final db = await SQLHelper.db(); // Membuka database
      return db.query(
        'tabelbrg', // Nama tabel
        where: "id = ?", // Kondisi untuk mencari berdasarkan ID
        whereArgs: [id], // ID barang yang dicari
        limit: 1, // Hanya mengambil satu data
      );
    } catch (err) {
      debugPrint("Error fetching item with ID $id: $err"); // Debug jika terjadi error
      return []; // Mengembalikan list kosong jika ada kesalahan
    }
  }

  // Memperbarui data barang berdasarkan ID
  static Future<int> updateItem(int id, String nama, String? harga) async {
    try {
      final db = await SQLHelper.db(); // Membuka database

      // Validasi: nama tidak boleh kosong
      if (nama.isEmpty) throw Exception("Nama barang tidak boleh kosong");

      // Data baru untuk memperbarui barang
      final data = {
        'nama': nama, // Nama baru
        'harga': harga, // Harga baru
        'createdAt': DateTime.now().toString(), // Perbarui waktu terakhir diperbarui
      };

      // Memperbarui data di tabel 'tabelbrg'
      final result =
          await db.update('tabelbrg', data, where: "id = ?", whereArgs: [id]);
      return result; // Mengembalikan jumlah baris yang diperbarui
    } catch (err) {
      debugPrint("Error updating item with ID $id: $err"); // Debug jika terjadi error
      return -1; // Indikasi kesalahan
    }
  }

  // Menghapus barang berdasarkan ID
  static Future<void> deleteItem(int id) async {
    try {
      final db = await SQLHelper.db(); // Membuka database
      await db.delete("tabelbrg", where: "id = ?", whereArgs: [id]); // Menghapus data dari tabel
      debugPrint("Item with ID $id deleted successfully"); // Debug jika berhasil dihapus
    } catch (err) {
      debugPrint("Error deleting item with ID $id: $err"); // Debug jika terjadi error
    }
  }
}
