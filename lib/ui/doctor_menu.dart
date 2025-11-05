/// Doctor Menu
///
/// Provides CLI interface for doctor-specific operations including:
/// - Viewing appointments
/// - Creating new appointments
/// - Issuing prescriptions
/// - Viewing patient history
library;

import 'package:prompts/prompts.dart' as prompts;
import 'package:dart_clinic/service/session_service.dart';
import 'doctor/manage_appointments.dart';
import 'doctor/manage_prescriptions.dart';
import 'doctor/search_patients.dart';

class DoctorMenu {
  /// Display the doctor menu and handle operations
  void display() {
    if (!_login()) {
      return;
    }

    while (true) {
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
          break;
        case 'Manage Prescriptions':
          ManagePrescriptions().display();
          break;
        case 'Manage Patients':
          SearchPatients().display();
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
      print('\n' + '=' * 50);
      print('👨‍⚕️  DOCTOR PORTAL LOGIN  👨‍⚕️');
      print('=' * 50);

      final email = prompts.get('Enter your email');

      if (email.trim() == '-b') {
        return false;
      }

      final password = prompts.get('Enter your password');

      if (email.isNotEmpty && password.isNotEmpty) {
        SessionService().loginDoctor(email, password);
        print(
          '\n✅ Login successful! Welcome, ${SessionService().currentDoctor!.name}',
        );
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
