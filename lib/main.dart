/// Hospital Management System - Main Entry Point
///
/// This is the entry point for the Hospital Management CLI application.
/// It initializes the UI and starts the main menu.
library;

import 'ui/main_menu.dart';
import 'ui/doctor_menu.dart';
import 'ui/manager_menu.dart';

void main() {
  // Initialize UI components
  final doctorMenu = DoctorMenu();
  final managerMenu = ManagerMenu();
  final mainMenu = MainMenu(doctorMenu: doctorMenu, managerMenu: managerMenu);

  // Start the application
  mainMenu.display();
}
