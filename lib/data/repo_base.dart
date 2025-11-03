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

  RepositoryBase(this.dbPath);

  /// Abstract methods - must be implemented by child classes
  Map<String, dynamic> toJson(T entity);
  T fromJson(Map<String, dynamic> json);

  /// Initialize the repository with database/path configuration
  Future<void> initialize() async {
    if (_initialized) return;

    final file = File(dbPath);
    if (!await file.exists()) {
      await file.parent.create(recursive: true);
      await file.writeAsString('[]');
    }
    _initialized = true;
  }

  /// Load all entities from storage
  Future<List<T>> loadAll() async {
    await initialize();
    final file = File(dbPath);
    final content = await file.readAsString();
    final List<dynamic> jsonList = json.decode(content);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Save entities list to storage
  Future<void> saveAll(List<T> entities) async {
    await initialize();
    final file = File(dbPath);
    final jsonList = entities.map((e) => toJson(e)).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  /// Create a new entity record
  Future<T?> create(T entity) async {
    final entities = await loadAll();
    entities.add(entity);
    await saveAll(entities);
    return entity;
  }

  /// Retrieve an entity by ID
  Future<T?> getById(String id) async {
    final entities = await loadAll();
    try {
      return entities.firstWhere((entity) => _getId(entity) == id);
    } catch (e) {
      return null;
    }
  }

  /// Update an existing entity
  Future<bool> update(T entity) async {
    final entities = await loadAll();
    final index = entities.indexWhere((e) => _getId(e) == _getId(entity));
    if (index == -1) return false;

    entities[index] = entity;
    await saveAll(entities);
    return true;
  }

  /// Delete an entity by ID
  Future<bool> delete(String id) async {
    final entities = await loadAll();
    final originalLength = entities.length;
    entities.removeWhere((entity) => _getId(entity) == id);
    final newLength = entities.length;
    await saveAll(entities);
    return newLength < originalLength;
  }

  /// Get all entities
  Future<List<T>> getAll() async {
    return await loadAll();
  }

  /// Extract ID from entity - to be implemented by child class if needed
  String _getId(T entity) {
    // This is a generic implementation that tries to read 'id' from the JSON
    // Child classes can override if needed
    final json = toJson(entity);
    return json['id'] as String;
  }
}
