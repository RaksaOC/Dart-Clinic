/// Manager Menu
///
/// Provides CLI interface for manager-specific operations including:
/// - Creating and managing rooms
/// - Managing doctors, patients, and admissions
/// - System administration
library;

import 'package:prompts/prompts.dart' as prompts;
import 'manager/manage_rooms.dart';
import 'manager/manage_doctors.dart';
import 'manager/manage_patients.dart';
import 'manager/manage_admissions.dart';
import 'manager/manage_managers.dart';
import 'package:dart_clinic/service/session_service.dart';

class ManagerMenu {
  /// Display the manager menu and handle operations
  void display() {
    // First, authenticate the manager
    if (!_login()) {
      return; // Return to main menu if login fails
    }

    while (true) {
      print('\n' + '=' * 50);
      print('MANAGER DASHBOARD');
      print(
        'Logged in as: ${SessionService().currentManager?.name ?? "Unknown"}',
      );
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
          ManageRooms().display();
          break;
        case 'Manage Doctors':
          ManageDoctors().display();
          break;
        case 'Manage Patients':
          ManagePatients().display();
          break;
        case 'Manage Admissions':
          ManageAdmissions().display();
          break;
        case 'Manage Managers':
          ManageManagers().display();
          break;
        case 'Logout':
          SessionService().logout();
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

      SessionService().loginManager(email.trim(), password);

      if (SessionService().currentManager != null) {
        print('\n✅ Login successful! Welcome, ${SessionService().currentManager!.name}');
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
