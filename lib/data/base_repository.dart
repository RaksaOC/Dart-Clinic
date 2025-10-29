import 'package:sqlite3/sqlite3.dart';

import 'database.dart';

// AI assisted in generating boilerplate code and params detection.
abstract class BaseRepository {
  BaseRepository(this.tableName);

  final String tableName;

  Database get _db => DatabaseProvider.instance.db;

  int insert(Map<String, Object?> values) {
    final columns = values.keys.toList();
    final placeholders = List.generate(columns.length, (_) => '?');
    final stmt = _db.prepare(
      'INSERT INTO $tableName (${columns.join(',')}) VALUES (${placeholders.join(',')})',
    );
    try {
      stmt.execute(values.values.toList());
      return _db.lastInsertRowId;
    } finally {
      stmt.dispose();
    }
  }

  int updateById(int id, Map<String, Object?> values) {
    final assignments = values.keys.map((k) => '$k = ?').join(', ');
    final params = [...values.values, id];
    final stmt = _db.prepare('UPDATE $tableName SET $assignments WHERE id = ?');
    try {
      stmt.execute(params);
      return _db.getUpdatedRows();
    } finally {
      stmt.dispose();
    }
  }

  int deleteById(int id) {
    final stmt = _db.prepare('DELETE FROM $tableName WHERE id = ?');
    try {
      stmt.execute([id]);
      return _db.getUpdatedRows();
    } finally {
      stmt.dispose();
    }
  }

  Map<String, Object?>? findById(int id) {
    final stmt = _db.prepare('SELECT * FROM $tableName WHERE id = ? LIMIT 1');
    try {
      final result = stmt.select([id]);
      if (result.isEmpty) return null;
      return result.first;
    } finally {
      stmt.dispose();
    }
  }

  List<Map<String, Object?>> findAll({
    String? where,
    List<Object?> params = const [],
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    final buffer = StringBuffer('SELECT * FROM $tableName');
    if (where != null && where.trim().isNotEmpty) {
      buffer.write(' WHERE $where');
    }
    if (orderBy != null && orderBy.trim().isNotEmpty) {
      buffer.write(' ORDER BY $orderBy');
    }
    if (limit != null) {
      buffer.write(' LIMIT $limit');
    }
    if (offset != null) {
      buffer.write(' OFFSET $offset');
    }
    final stmt = _db.prepare(buffer.toString());
    try {
      final result = stmt.select(params);
      return result.toList();
    } finally {
      stmt.dispose();
    }
  }
}
