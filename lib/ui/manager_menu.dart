/// Manager Menu
///
/// Provides CLI interface for manager-specific operations including:
/// - Creating and managing rooms
/// - Managing doctors, patients, and admissions
/// - System administration
library;

import 'package:prompts/prompts.dart' as prompts;
import '../domain/models/manager.dart';
import '../domain/usecases/manager.dart' as manager_use_case;
import 'main_menu.dart';
import 'manager/manage_rooms.dart';
import 'manager/manage_doctors.dart';
import 'manager/manage_patients.dart';
import 'manager/manage_admissions.dart';
import 'manager/manage_managers.dart';

class ManagerMenu {
  final manager_use_case.Manager _manager;
  ManagerModel? currentManager;

  ManagerMenu({required manager_use_case.Manager manager}) : _manager = manager;

  /// Display the manager menu and handle operations
  void display(MainMenu mainMenu) {
    // First, authenticate the manager
    if (!_login()) {
      return; // Return to main menu if login fails
    }

    while (true) {
      print('\n' + '=' * 50);
      print('MANAGER DASHBOARD');
      print('Logged in as: ${currentManager?.name ?? "Unknown"}');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Manage Rooms',
        'Manage Doctors',
        'Manage Patients',
        'Manage Admissions',
        'Manage Managers',
        'Logout',
      ]);

      switch (choice) {
        case 'Manage Rooms':
          ManageRooms(_manager).display();
          break;
        case 'Manage Doctors':
          ManageDoctors(_manager).display();
          break;
        case 'Manage Patients':
          ManagePatients(_manager).display();
          break;
        case 'Manage Admissions':
          ManageAdmissions(_manager).display();
          break;
        case 'Manage Managers':
          ManageManagers(_manager, currentManager).display();
          break;
        case 'Logout':
          currentManager = null;
          print('\n👋 Logged out successfully!\n');
          return;
      }
    }
  }

  /// Manager login
  bool _login() {
    while (true) {
      print('\n' + '=' * 50);
      print('👔 MANAGER PORTAL LOGIN  👔');
      print('=' * 50);

      final email = prompts.get('Enter your email (or type -b to go back)');

      if (email.trim() == '-b') {
        return false;
      }

      final password = prompts.get('Enter your password');

      currentManager = _manager.authenticateManager(email.trim(), password);

      if (currentManager != null) {
        print('\n✅ Login successful! Welcome, ${currentManager!.name}');
        return true;
      } else {
        print('\n❌ Invalid credentials. Please try again.\n');
        final retry = prompts.getBool('Do you want to try again? (y/n)');
        if (!retry) {
          return false;
        }
      }
    }
  }
}
