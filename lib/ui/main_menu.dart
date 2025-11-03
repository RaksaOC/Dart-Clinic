/// Main Menu
///
/// Provides the primary entry point CLI interface for the Hospital Management System.
/// Allows users to navigate to different role-based menus (Doctor, Admin, Patient).
library;

import 'package:prompts/prompts.dart' as prompts;
import 'dart:io';
import 'doctor_menu.dart';
import 'admin_menu.dart';

class MainMenu {
  final DoctorMenu doctorMenu;
  final AdminMenu adminMenu;

  MainMenu({required this.doctorMenu, required this.adminMenu});

  /// Display the main menu and handle user navigation
  void display() {
    _showWelcomeMessage();

    final role = prompts.choose('\nSelect a portal:', [
      'Doctor Portal',
      'Admin Portal',
      'Exit',
    ]);

    switch (role) {
      case 'Doctor Portal':
        doctorMenu.display(this);
        display(); // Return to main menu after logout
        break;
      case 'Admin Portal':
        adminMenu.display(this);
        display(); // Return to main menu after logout
        break;
      case 'Exit':
        _exit();
        break;
    }
  }

  /// Show welcome message
  void _showWelcomeMessage() {
    print('\n' + '=' * 50);
    print('🏥  HOSPITAL MANAGEMENT SYSTEM  🏥');
    print('=' * 50);
  }

  /// Exit the application
  void _exit() {
    print('\n👋 Thank you for using Hospital Management System!');
    print('Have a great day!\n');
    exit(0);
  }
}
