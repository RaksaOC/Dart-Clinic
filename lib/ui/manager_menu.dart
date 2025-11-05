/// Manager Menu
///
/// Provides CLI interface for manager-specific operations including:
/// - Creating and managing rooms
/// - Assigning patients to rooms
/// - Managing medication stock
/// - Generating reports
/// - System administration
library;

import 'package:prompts/prompts.dart' as prompts;
import '../domain/manager.dart';
import 'main_menu.dart';

class ManagerMenu {
  Manager? currentManager;

  /// Display the admin menu and handle operations
  void display(MainMenu mainMenu) {
    // First, authenticate the admin
    if (!_login()) {
      return; // Return to main menu if login fails
    }

    while (true) {
      print('\n' + '-' * 50);
      print('MANAGER MENU');
      print('Logged in as: ${currentManager?.name ?? "Unknown"}');
      print('-' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Create Room',
        'Manage Rooms',
        'Assign Patient to Room',
        'Manage Medication Stock',
        'Generate Reports',
        'View System Statistics',
        'Manage Users',
        'Logout',
      ]);

      switch (choice) {
        case 'Create Room':
          _createRoom();
          break;
        case 'Manage Rooms':
          _manageRooms();
          break;
        case 'Assign Patient to Room':
          _assignPatientToRoom();
          break;
        case 'Manage Medication Stock':
          _manageMedicationStock();
          break;
        case 'Generate Reports':
          _generateReports();
          break;
        case 'View System Statistics':
          _viewSystemStatistics();
          break;
        case 'Manage Users':
          _manageUsers();
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

      // TODO: Implement actual authentication
      // For now, use mock credentials
      if (email == 'manager@hospital.com' && password == 'manager123') {
        currentManager = Manager(
          id: 'M001',
          name: 'Manager',
          email: email,
          password: password,
          age: 30,
          gender: 'Male',
          phoneNumber: '555-0101',
          address: '123 Main St, Anytown, USA',
        );
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

  /// Create a new room
  void _createRoom() {
    print('\n🏥 CREATE ROOM');
    print('-' * 50);
    // TODO: Implement room creation
    print('\n⏳ Feature coming soon...');
  }

  /// Assign patient to room
  void _assignPatientToRoom() {
    print('\n🛏️  ASSIGN PATIENT TO ROOM');
    print('-' * 50);
    // TODO: Implement patient assignment to room
    print('\n⏳ Feature coming soon...');
  }

  /// Manage rooms
  void _manageRooms() {
    print('\n🏥 MANAGE ROOMS');
    print('-' * 50);
    // TODO: Implement room management
    print('\n⏳ Feature coming soon...');
  }

  /// Manage medication stock
  void _manageMedicationStock() {
    print('\n💊 MANAGE MEDICATION STOCK');
    print('-' * 50);
    // TODO: Implement medication stock management
    print('\n⏳ Feature coming soon...');
  }

  /// Generate reports
  void _generateReports() {
    print('\n📊 GENERATE REPORTS');
    print('-' * 50);
    // TODO: Implement report generation
    print('\n⏳ Feature coming soon...');
  }

  /// View system statistics
  void _viewSystemStatistics() {
    print('\n📈 SYSTEM STATISTICS');
    print('-' * 50);
    // TODO: Implement system statistics
    print('\n⏳ Feature coming soon...');
  }

  /// Manage users
  void _manageUsers() {
    print('\n👥 MANAGE USERS');
    print('-' * 50);
    // TODO: Implement user management
    print('\n⏳ Feature coming soon...');
  }
}
