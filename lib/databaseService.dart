import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  final StreamController<void> _wasteUpdateController =
      StreamController<void>.broadcast();
  Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Stream<void> get wasteUpdates => _wasteUpdateController.stream;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If database doesn't exist, create it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'trash_system.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE waste (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            waste_type_id INTEGER,
            weight REAL,
            waste_name TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE waste_data_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            waste_id INTEGER,
            created_at TEXT,
            log_created_at TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (waste_id) REFERENCES waste(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE waste_collections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            collection_date TEXT,
            landfill_id INTEGER,
            waste_type_id INTEGER,
            quantity REAL,
            vehicle_id INTEGER,
            status TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
      },
    );
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    try {
      await db.delete('users');
      print("All users deleted successfully.");
    } catch (e) {
      print("Error deleting users: $e");
    }
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> createUser(String email, String password, String name) async {
    final db = await database;
    try {
      await db.insert(
          'users', {'email': email, 'password': password, 'name': name});
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<void> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    try {
      await db.update('users', {'password': newPassword},
          where: 'email = ?', whereArgs: [email]);
    } catch (e) {
      print("Error updating password: $e");
    }
  }

  Future<void> deleteUserAccount(String email) async {
    final db = await database;
    try {
      await db.delete('users', where: 'email = ?', whereArgs: [email]);
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> addWaste(
      int userID, int wasteTypeId, double weight, String wasteName) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Insert waste entry
        int wasteId = await txn.insert('waste', {
          'user_id': userID,
          'waste_type_id': wasteTypeId,
          'weight': weight,
          'waste_name': wasteName,
        });

        // Insert log entry
        await txn.insert('waste_data_log', {
          'user_id': userID,
          'waste_id': wasteId,
          'created_at': DateTime.now().toIso8601String(),
          'log_created_at': DateTime.now().toIso8601String(),
        });
      });

      _wasteUpdateController.add(null);
    } catch (e) {
      print("Error adding waste: $e");
    }
  }

  Future<double> getTotalWasteByType(int userId, int wasteTypeId) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> results = await db.rawQuery(
          'SELECT SUM(weight) as total_weight FROM waste WHERE user_id = ? AND waste_type_id = ?',
          [userId, wasteTypeId]);
      return results.first['total_weight'] ?? 0.0;
    } catch (e) {
      print("Error getting total waste by type: $e");
      return 0.0;
    }
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
    final db = await database;
    try {
      List<Map<String, dynamic>> results = await db.query('waste_data_log');
      return results;
    } catch (e) {
      print("Error getting logs: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserLogs(int userId) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT wdl.id AS log_id, w.id AS waste_id, w.user_id, w.waste_type_id, w.weight, w.waste_name,
               wdl.created_at, wdl.log_created_at
        FROM waste_data_log wdl
        INNER JOIN waste w ON wdl.waste_id = w.id
        WHERE w.user_id = ?
      ''', [userId]);

      return results;
    } catch (e) {
      print("Error getting user logs: $e");
      return [];
    }
  }

  Future<void> addWasteCollection(int userId, int landfillId, int wasteTypeId,
      double quantity, int vehicleId, String status) async {
    final db = await database;
    try {
      await db.insert('waste_collections', {
        'user_id': userId,
        'collection_date': DateTime.now().toIso8601String(),
        'landfill_id': landfillId,
        'waste_type_id': wasteTypeId,
        'quantity': quantity,
        'vehicle_id': vehicleId,
        'status': status
      });
      _wasteUpdateController.add(null);
    } catch (e) {
      print("Error adding waste collection: $e");
    }
  }

  void resetPassword(String email) {}

  void dispose() {
    _wasteUpdateController.close();
  }

  sendPasswordResetEmail(String email) {}
}
