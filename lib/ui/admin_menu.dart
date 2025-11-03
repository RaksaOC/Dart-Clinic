/// Admin Menu
///
/// Provides CLI interface for admin-specific operations including:
/// - Managing rooms and beds
/// - Managing medication stock
/// - Generating reports
/// - System administration
library;

import 'package:prompts/prompts.dart' as prompts;
import '../domain/admin.dart';
import 'main_menu.dart';

class AdminMenu {
  Admin? currentAdmin;

  /// Display the admin menu and handle operations
  void display(MainMenu mainMenu) {
    // First, authenticate the admin
    if (!_login()) {
      return; // Return to main menu if login fails
    }

    while (true) {
      print('\n' + '-' * 50);
      print('ADMIN MENU');
      print('Logged in as: ${currentAdmin?.name ?? "Unknown"}');
      print('-' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Manage Rooms',
        'Manage Medication Stock',
        'Generate Reports',
        'View System Statistics',
        'Manage Users',
        'Logout',
      ]);

      switch (choice) {
        case 'Manage Rooms':
          _manageRooms();
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
          currentAdmin = null;
          print('\n👋 Logged out successfully!\n');
          return;
      }
    }
  }

  /// Admin login
  bool _login() {
    while (true) {
      print('\n' + '=' * 50);
      print('👔 ADMIN PORTAL LOGIN  👔');
      print('=' * 50);

      final email = prompts.get('Enter your email (or type -b to go back)');

      if (email.trim() == '-b') {
        return false;
      }

      final password = prompts.get('Enter your password');

      // TODO: Implement actual authentication
      // For now, use mock credentials
      if (email == 'admin@hospital.com' && password == 'admin123') {
        currentAdmin = Admin(
          id: 'A001',
          name: 'Administrator',
          email: email,
          password: password,
        );
        print('\n✅ Login successful! Welcome, ${currentAdmin!.name}');
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
