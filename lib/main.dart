/// Hospital Management System - Main Entry Point
///
/// This is the entry point for the Hospital Management CLI application.
/// It initializes the UI and starts the main menu.
library;

import 'ui/main_menu.dart';

void main() {
  MainMenu mainMenu = MainMenu();
  mainMenu.display();
}
