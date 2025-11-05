/// Repository Base
///
/// Abstract base class that provides common CRUD operations for repositories.
/// Child classes only need to implement JSON serialization methods.
library;

import 'dart:convert';
import 'dart:io';

abstract class RepositoryBase<T> {
  final String dbPath;
  bool _initialized = false;

  RepositoryBase(this.dbPath) {
    initialize();
  }

  /// Abstract methods - must be implemented by child classes
  Map<String, dynamic> toJson(T entity);
  T fromJson(Map<String, dynamic> json);

  /// Initialize the repository with database/path configuration
  void initialize() {
    if (_initialized) return;

    final file = File(dbPath);
    if (!file.existsSync()) {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync('[]');
    }
    _initialized = true;
  }

  /// Load all entities from storage
  List<T> loadAll() {
    initialize();
    final file = File(dbPath);
    final content = file.readAsStringSync();
    final List<dynamic> jsonList = json.decode(content);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Save entities list to storage
  void saveAll(List<T> entities) {
    initialize();
    final file = File(dbPath);
    final jsonList = entities.map((e) => toJson(e)).toList();
    file.writeAsStringSync(json.encode(jsonList));
  }

  /// Create a new entity record
  T? create(T entity) {
    final entities = loadAll();
    entities.add(entity);
    saveAll(entities);
    return entity;
  }

  /// Retrieve an entity by ID
  T? getById(String id) {
    final entities = loadAll();
    try {
      return entities.firstWhere((entity) => _getId(entity) == id);
    } catch (e) {
      return null;
    }
  }

  /// Update an existing entity
  bool update(T entity) {
    final entities = loadAll();
    final index = entities.indexWhere((e) => _getId(e) == _getId(entity));
    if (index == -1) return false;

    entities[index] = entity;
    saveAll(entities);
    return true;
  }

  /// Delete an entity by ID
  bool delete(String id) {
    final entities = loadAll();
    final originalLength = entities.length;
    entities.removeWhere((entity) => _getId(entity) == id);
    final newLength = entities.length;
    saveAll(entities);
    return newLength < originalLength;
  }

  /// Get all entities
  List<T> getAll() {
    return loadAll();
  }

  /// Extract ID from entity - to be implemented by child class if needed
  String _getId(T entity) {
    // This is a generic implementation that tries to read 'id' from the JSON
    // Child classes can override if needed
    final json = toJson(entity);
    return json['id'] as String;
  }
}
