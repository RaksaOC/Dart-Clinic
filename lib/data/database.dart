import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

// AI assited in generating this database connection
class DatabaseProvider {
  DatabaseProvider._internal();

  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static DatabaseProvider get instance => _instance;

  Database? _db;

  Database get db {
    final database = _db;
    if (database == null) {
      throw StateError('Database not initialized. Call init() first.');
    }
    return database;
  }

  /// Initializes the database connection to lib/dart_clinic.db and ensures schema exists.
  void init() {
    if (_db != null) return;

    final projectRoot = Directory.current.path;
    final dbPath = p.join(projectRoot, 'lib', 'dart_clinic.db');
    final ddlPath = p.join(projectRoot, 'lib', 'DDL.sql');

    _db = sqlite3.open(dbPath);

    // If core table 'staff' doesn't exist, bootstrap schema from DDL.sql
    final existsStmt = db.prepare(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
    );
    final exists = existsStmt.select(['staff']).isNotEmpty;
    existsStmt.dispose();

    if (!exists) {
      final ddlFile = File(ddlPath);
      if (!ddlFile.existsSync()) {
        throw StateError('DDL.sql not found at $ddlPath');
      }
      final ddl = ddlFile.readAsStringSync();
      _executeSqlScript(ddl);
    }
  }

  void close() {
    _db?.dispose();
    _db = null;
  }

  void _executeSqlScript(String script) {
    // Naive split by semicolon; ignores semicolons inside strings which we don't have here.
    final statements = script
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && !s.startsWith('--'));
    for (final stmt in statements) {
      db.execute(stmt);
    }
  }
}
