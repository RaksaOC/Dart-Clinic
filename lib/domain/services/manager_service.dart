/// Manager Service
///
/// Handles business logic for manager operations including:
/// - Manager authentication
/// - Managing manager records
///
/// Coordinates between the UI layer and manager repository.
library;

import '../models/manager.dart';
import '../../data/manager_repo.dart';
import 'package:uuid/uuid.dart';

class ManagerService {
  final ManagerRepository _managerRepository;

  ManagerService([ManagerRepository? repository])
    : _managerRepository = repository ?? ManagerRepository();

  /// Create a new manager
  ManagerModel? createManager({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    required String phoneNumber,
    required String address,
  }) {
    final String id = const Uuid().v4();
    // Uniqueness check
    if (_managerRepository.getById(id) != null) {
      return null;
    }
    final manager = ManagerModel(
      id: id,
      name: name,
      email: email,
      password: password,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      address: address,
    );
    return _managerRepository.create(manager);
  }

  /// Update manager information
  bool updateManager(ManagerModel manager) {
    return _managerRepository.update(manager);
  }

  /// Delete a manager
  bool deleteManager(String managerId) {
    return _managerRepository.delete(managerId);
  }

  /// Get all managers
  List<ManagerModel> getAllManagers() {
    return _managerRepository.getAll();
  }

  /// Get manager by ID
  ManagerModel? getManagerById(String managerId) {
    return _managerRepository.getById(managerId);
  }

  /// Find manager by email
  ManagerModel? findManagerByEmail(String email) {
    final managers = _managerRepository.getAll();
    try {
      return managers.firstWhere((manager) => manager.email == email);
    } catch (e) {
      return null;
    }
  }
}
