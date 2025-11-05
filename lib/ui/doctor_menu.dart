/// Doctor Menu
///
/// Provides CLI interface for doctor-specific operations including:
/// - Viewing appointments
/// - Creating new appointments
/// - Issuing prescriptions
/// - Viewing patient history
library;

import 'package:prompts/prompts.dart' as prompts;
import 'package:dart_clinic/services/session_service.dart';
import 'doctor/manage_appointments.dart';
import 'doctor/manage_prescriptions.dart';
import 'doctor/search_patients.dart';
import 'package:dart_clinic/utils/terminal.dart';

class DoctorMenu {
  /// Display the doctor menu and handle operations
  void display() {
    if (!_login()) {
      return;
    }

    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '-' * 50);
      print('DOCTOR MENU');
      print(
        'Logged in as: ${SessionService().currentDoctor?.name ?? "Unknown"}',
      );
      print('-' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Manage Appointments',
        'Manage Prescriptions',
        'Manage Patients',
        'Logout',
      ]);

      switch (choice) {
        case 'Manage Appointments':
          ManageAppointments().display();
          TerminalUI.pauseAndClear();
          break;
        case 'Manage Prescriptions':
          ManagePrescriptions().display();
          TerminalUI.pauseAndClear();
          break;
        case 'Manage Patients':
          SearchPatients().display();
          TerminalUI.pauseAndClear();
          break;
        case 'Logout':
          SessionService().logout();
          print('\n👋 Logged out successfully!\n');
          return;
      }
    }
  }

  /// Doctor login
  bool _login() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('DOCTOR PORTAL LOGIN');
      print('=' * 50);

      final email = prompts.get('Enter your email');

      if (email.trim() == '-b') {
        return false;
      }

      final password = prompts.get('Enter your password');

      if (email.isNotEmpty && password.isNotEmpty) {
        final doctor = SessionService().loginDoctor(email, password);
        if (doctor != null) {
          print('\nLogin successful. Welcome, ${doctor.name}');
          return true;
        }
      }

      print('\nInvalid credentials. Please try again.\n');
      final retry = prompts.getBool('Do you want to try again? (y/n)');
      if (!retry) {
        return false;
      }
    }
  }
}
