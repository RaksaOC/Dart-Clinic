/// Manage Managers UI
///
/// Provides CLI interface for manager management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/manager.dart';
import '../../domain/usecases/manager.dart' as manager_use_case;

class ManageManagers {
  final manager_use_case.Manager _manager;
  final ManagerModel? currentManager;

  ManageManagers(this._manager, this.currentManager);

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('👔 MANAGE MANAGERS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Create Manager',
        'View All Managers',
        'Update Manager',
        'Delete Manager',
        'Back to Main Menu',
      ]);

      switch (choice) {
        case 'Create Manager':
          _createManager();
          break;
        case 'View All Managers':
          _viewAllManagers();
          break;
        case 'Update Manager':
          _updateManager();
          break;
        case 'Delete Manager':
          _deleteManager();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createManager() {
    print('\n👔 CREATE MANAGER');
    print('-' * 50);

    try {
      final managerId = prompts.get('Manager ID (e.g., M001):');
      final name = prompts.get('Name:');
      final email = prompts.get('Email:');
      final password = prompts.get('Password:');
      final age = int.parse(prompts.get('Age:'));
      final gender = prompts.choose('Gender:', ['Male', 'Female', 'Other']);
      final phoneNumber = prompts.get('Phone Number:');
      final address = prompts.get('Address:');

      final manager = _manager.createManager(
        managerId: managerId.trim(),
        name: name.trim(),
        email: email.trim(),
        password: password,
        age: age,
        gender: gender ?? '',
        phoneNumber: phoneNumber.trim(),
        address: address.trim(),
      );

      if (manager != null) {
        print('\n✅ Manager created successfully!');
        print('Manager ID: ${manager.id}');
        print('Name: ${manager.name}');
      } else {
        print('\n❌ Failed to create manager. Manager ID might already exist.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewAllManagers() {
    print('\n👔 ALL MANAGERS');
    print('-' * 50);
    final managers = _manager.getAllManagers();
    if (managers.isEmpty) {
      print('\nNo managers found.');
      return;
    }

    print(
      '\n${'ID'.padRight(8)} ${'Name'.padRight(25)} ${'Email'.padRight(30)}',
    );
    print('-' * 70);
    for (final manager in managers) {
      print(
        '${manager.id.padRight(8)} ${manager.name.padRight(25)} ${manager.email.padRight(30)}',
      );
    }
  }

  void _updateManager() {
    print('\n✏️  UPDATE MANAGER');
    print('-' * 50);
    final managerId = prompts.get('Enter Manager ID to update:');
    final manager = _manager.getManagerById(managerId.trim());

    if (manager == null) {
      print('\n❌ Manager not found.');
      return;
    }

    print('\nCurrent Manager Details:');
    print('Name: ${manager.name}');
    print('Email: ${manager.email}');
    print('Phone: ${manager.phoneNumber}');
    print('Address: ${manager.address}');

    final newName = prompts.get('New Name (or press Enter to keep):');
    final newEmail = prompts.get('New Email (or press Enter to keep):');
    final newPhone = prompts.get('New Phone Number (or press Enter to keep):');
    final newAddress = prompts.get('New Address (or press Enter to keep):');

    final updatedManager = ManagerModel(
      id: manager.id,
      name: newName.trim().isEmpty ? manager.name : newName.trim(),
      email: newEmail.trim().isEmpty ? manager.email : newEmail.trim(),
      password: manager.password,
      age: manager.age,
      gender: manager.gender,
      phoneNumber: newPhone.trim().isEmpty
          ? manager.phoneNumber
          : newPhone.trim(),
      address: newAddress.trim().isEmpty ? manager.address : newAddress.trim(),
    );

    if (_manager.updateManager(updatedManager)) {
      print('\n✅ Manager updated successfully!');
    } else {
      print('\n❌ Failed to update manager.');
    }
  }

  void _deleteManager() {
    print('\n🗑️  DELETE MANAGER');
    print('-' * 50);
    final managerId = prompts.get('Enter Manager ID to delete:');
    final manager = _manager.getManagerById(managerId.trim());

    if (manager == null) {
      print('\n❌ Manager not found.');
      return;
    }

    // Prevent deleting yourself
    if (currentManager != null && manager.id == currentManager!.id) {
      print('\n❌ Cannot delete yourself.');
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to delete this manager? (y/n)',
    );
    if (confirm) {
      if (_manager.deleteManager(managerId.trim())) {
        print('\n✅ Manager deleted successfully!');
      } else {
        print('\n❌ Failed to delete manager.');
      }
    }
  }
}
