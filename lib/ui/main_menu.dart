/// Main Menu
///
/// Provides the primary entry point CLI interface for the Hospital Management System.
/// Allows users to navigate to different role-based menus (Doctor, Manager).
library;

import 'package:prompts/prompts.dart' as prompts;
import 'dart:io';
import 'doctor_menu.dart';
import 'manager_menu.dart';
import 'package:dart_clinic/utils/terminal.dart';

class MainMenu {
  final DoctorMenu doctorMenu;
  final ManagerMenu managerMenu;

  MainMenu() : doctorMenu = DoctorMenu(), managerMenu = ManagerMenu();

  /// Display the main menu and handle user navigation
  void display() {
    TerminalUI.clearScreen();
    _showWelcomeMessage();

    final role = prompts.choose('\nSelect a portal:', [
      'Doctor Portal',
      'Manager Portal',
      'Exit',
    ]);

    switch (role) {
      case 'Doctor Portal':
        doctorMenu.display();
        TerminalUI.pauseAndClear();
        display(); 
        break;
      case 'Manager Portal':
        managerMenu.display();
        TerminalUI.pauseAndClear();
        display(); 
        break;
      case 'Exit':
        _exit();
        break;
    }
  }

  /// Show welcome message
  void _showWelcomeMessage() {
    print('\n' + '=' * 50);
    print('HOSPITAL MANAGEMENT SYSTEM');
    print('=' * 50);
  }

  /// Exit the application
  void _exit() {
    print('\nThank you for using Hospital Management System.');
    print('Have a great day!\n');
    exit(0);
  }
}
