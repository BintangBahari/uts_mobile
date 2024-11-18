import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Membuat tabel barang
  static Future<void> createTables(sql.Database database) async {
    try {
      await database.execute("""
      CREATE TABLE tabelbrg(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama TEXT NOT NULL,
        harga TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
      debugPrint("Table 'tabelbrg' created successfully");
    } catch (err) {
      debugPrint("Error creating table: $err");
    }
  }

  // Membuka atau membuat database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'hrgBrg.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Menambahkan barang baru
  static Future<int> createItem(String nama, String? harga) async {
    try {
      final db = await SQLHelper.db();

      // Validasi nama tidak boleh kosong
      if (nama.isEmpty) throw Exception("Nama barang tidak boleh kosong");

      final data = {'nama': nama, 'harga': harga};
      final id = await db.insert(
        'tabelbrg',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return id;
    } catch (err) {
      debugPrint("Error inserting item: $err");
      return -1; // Indikasi kesalahan
    }
  }

  // Membaca semua barang
  static Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final db = await SQLHelper.db();
      return db.query('tabelbrg', orderBy: "id");
    } catch (err) {
      debugPrint("Error fetching items: $err");
      return [];
    }
  }

  // Membaca sebuah barang berdasarkan ID
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    try {
      final db = await SQLHelper.db();
      return db.query('tabelbrg', where: "id = ?", whereArgs: [id], limit: 1);
    } catch (err) {
      debugPrint("Error fetching item with ID $id: $err");
      return [];
    }
  }

  // Memperbarui barang berdasarkan ID
  static Future<int> updateItem(int id, String nama, String? harga) async {
    try {
      final db = await SQLHelper.db();

      // Validasi nama tidak boleh kosong
      if (nama.isEmpty) throw Exception("Nama barang tidak boleh kosong");

      final data = {
        'nama': nama,
        'harga': harga,
        'createdAt': DateTime.now().toString(),
      };

      final result =
          await db.update('tabelbrg', data, where: "id = ?", whereArgs: [id]);
      return result;
    } catch (err) {
      debugPrint("Error updating item with ID $id: $err");
      return -1; // Indikasi kesalahan
    }
  }

  // Menghapus barang berdasarkan ID
  static Future<void> deleteItem(int id) async {
    try {
      final db = await SQLHelper.db();
      await db.delete("tabelbrg", where: "id = ?", whereArgs: [id]);
      debugPrint("Item with ID $id deleted successfully");
    } catch (err) {
      debugPrint("Error deleting item with ID $id: $err");
    }
  }
}
