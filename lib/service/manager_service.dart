/// Manager Service
///
/// Handles business logic for manager operations including:
/// - Manager authentication
/// - Managing manager records
///
/// Coordinates between the UI layer and manager repository.
library;

import '../domain/manager.dart';
import '../data/manager_repo.dart';

class ManagerService {
  final ManagerRepository _managerRepository;

  ManagerService(this._managerRepository);

  /// Get all managers
  List<Manager> getAllManagers() {
    return _managerRepository.getAll();
  }

  /// Get manager by ID
  Manager? getManagerById(String managerId) {
    return _managerRepository.getById(managerId);
  }

  /// Find manager by email
  Manager? findManagerByEmail(String email) {
    final managers = _managerRepository.getAll();
    try {
      return managers.firstWhere((manager) => manager.email == email);
    } catch (e) {
      return null;
    }
  }

  /// Authenticate manager
  Manager? authenticateManager(String email, String password) {
    final manager = findManagerByEmail(email);
    if (manager != null &&
        manager.email == email &&
        manager.password == password) {
      return manager;
    }
    return null;
  }

  /// Create a new manager
  Manager? createManager({
    required String managerId,
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    required String phoneNumber,
    required String address,
  }) {
    final manager = Manager(
      id: managerId,
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
  bool updateManager(Manager manager) {
    return _managerRepository.update(manager);
  }

  /// Delete a manager
  bool deleteManager(String managerId) {
    return _managerRepository.delete(managerId);
  }
}
