/// Manage Managers UI
///
/// Provides CLI interface for manager management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/manager.dart';
import '../../domain/controllers/manager/managers_controller.dart';
import 'package:dart_clinic/services/session_service.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';

class ManageManagers {
  final ManagersController _manager;

  ManageManagers() : _manager = ManagersController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE MANAGERS');
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
          TerminalUI.pauseAndClear();
          break;
        case 'View All Managers':
          _viewAllManagers();
          TerminalUI.pauseAndClear();
          break;
        case 'Update Manager':
          _updateManager();
          TerminalUI.pauseAndClear();
          break;
        case 'Delete Manager':
          _deleteManager();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createManager() {
    print('\nCREATE MANAGER');
    print('-' * 50);

    try {
      final name = prompts.get('Name:');
      final email = prompts.get('Email:');
      final password = prompts.get('Password:');
      final age = int.parse(prompts.get('Age:'));
      final gender = prompts.choose('Gender:', ['Male', 'Female', 'Other']);
      final phoneNumber = prompts.get('Phone Number:');
      final address = prompts.get('Address:');

      final manager = _manager.createManager(
        name: name.trim(),
        email: email.trim(),
        password: password,
        age: age,
        gender: gender ?? '',
        phoneNumber: phoneNumber.trim(),
        address: address.trim(),
      );

      if (manager != null) {
        print('\nManager created successfully.');
        print('Manager ID: ${manager.id}');
        print('Name: ${manager.name}');
      } else {
        print('\nFailed to create manager. Manager ID might already exist.');
      }
    } catch (e) {
      print('\nError: ${e.toString()}');
    }
  }

  void _viewAllManagers() {
    print('\nALL MANAGERS');
    print('-' * 50);
    final managers = _manager.getAllManagers();
    if (managers.isEmpty) {
      print('\nNo managers found.');
      return;
    }

    final options = formatCardOptions(managers);
    for (final line in options) {
      print(line);
    }
  }

  void _updateManager() {
    print('\nUPDATE MANAGER');
    print('-' * 50);
    final managers = _manager.getAllManagers();
    if (managers.isEmpty) {
      print('\nNo managers found.');
      return;
    }

    final options = formatCardOptions(managers);
    final chosen = prompts.choose('Select a manager to update:', options);
    final idx = options.indexOf(chosen!);
    final manager = managers[idx];

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
      print('\nManager updated successfully.');
    } else {
      print('\nFailed to update manager.');
    }
  }

  void _deleteManager() {
    print('\nDELETE MANAGER');
    print('-' * 50);
    final managers = _manager.getAllManagers();
    if (managers.isEmpty) {
      print('\nNo managers found.');
      return;
    }

    final options = formatCardOptions(managers);
    final chosen = prompts.choose('Select a manager to delete:', options);
    final idx = options.indexOf(chosen!);
    final manager = managers[idx];

    // Prevent deleting yourself
    if (SessionService().currentManager != null &&
        manager.id == SessionService().currentManager!.id) {
      print('\nCannot delete yourself.');
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to delete this manager? (y/n)',
    );
    if (confirm) {
      if (_manager.deleteManager(manager.id)) {
        print('\nManager deleted successfully.');
      } else {
        print('\nFailed to delete manager.');
      }
    }
  }
}
