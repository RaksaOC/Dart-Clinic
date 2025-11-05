/// Doctor Menu
///
/// Provides CLI interface for doctor-specific operations including:
/// - Viewing appointments
/// - Creating new appointments
/// - Issuing prescriptions
/// - Viewing patient history
library;

import 'package:prompts/prompts.dart' as prompts;
import '../domain/doctor.dart';
import 'main_menu.dart';

class DoctorMenu {
  Doctor? currentDoctor;

  /// Display the doctor menu and handle operations
  void display(MainMenu mainMenu) {
    // First, authenticate the doctor
    if (!_login()) {
      return; // Return to main menu if login fails
    }

    while (true) {
      print('\n' + '-' * 50);
      print('DOCTOR MENU');
      print('Logged in as: ${currentDoctor?.name ?? "Unknown"}');
      print('-' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'View My Appointments',
        'Create Appointment',
        'Issue Prescription',
        'View Patient History',
        'Cancel Appointment',
        'Logout',
      ]);

      switch (choice) {
        case 'View My Appointments':
          _viewMyAppointments();
          break;
        case 'Create Appointment':
          _createAppointment();
          break;
        case 'Issue Prescription':
          _issuePrescription();
          break;
        case 'View Patient History':
          _viewPatientHistory();
          break;
        case 'Cancel Appointment':
          _cancelAppointment();
          break;
        case 'Logout':
          currentDoctor = null;
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

      final email = prompts.get('Enter your email (or type -b to go back)');

      if (email.trim() == '-b') {
        return false;
      }

      final password = prompts.get('Enter your password');

      // TODO: Implement actual authentication
      // For now, use mock credentials
      if (email == 'doctor@hospital.com' && password == 'doctor123') {
        currentDoctor = Doctor(
          id: 'D001',
          name: 'Dr. John Doe',
          specialization: 'General Medicine',
          phoneNumber: '555-0101',
          email: email,
          address: '123 Main St, Anytown, USA',
          age: 30,
          gender: 'Male',
          password: password,
        );
        print('\n✅ Login successful! Welcome, ${currentDoctor!.name}');
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

  /// Display all appointments for the logged-in doctor
  void _viewMyAppointments() {
    print('\n📅 VIEW MY APPOINTMENTS');
    print('-' * 50);
    // TODO: Fetch and display appointments from appointment service
    print('\n⏳ Feature coming soon...');
  }

  /// Create a new appointment
  void _createAppointment() {
    print('\n📝 CREATE APPOINTMENT');
    print('-' * 50);
    // TODO: Collect appointment details from user
    // TODO: Validate input
    // TODO: Create appointment via appointment service
    print('\n⏳ Feature coming soon...');
  }

  /// Issue a prescription to a patient
  void _issuePrescription() {
    print('\n💊 ISSUE PRESCRIPTION');
    print('-' * 50);
    // TODO: Collect prescription details from user
    // TODO: Validate input
    // TODO: Create prescription via prescription service
    print('\n⏳ Feature coming soon...');
  }

  /// View a patient's medical history
  void _viewPatientHistory() {
    print('\n📋 VIEW PATIENT HISTORY');
    print('-' * 50);
    // TODO: Request patient ID from user
    // TODO: Fetch patient history
    // TODO: Display appointments and prescriptions
    print('\n⏳ Feature coming soon...');
  }

  /// Cancel an appointment
  void _cancelAppointment() {
    print('\n❌ CANCEL APPOINTMENT');
    print('-' * 50);
    // TODO: Request appointment ID from user
    // TODO: Validate cancellation rules
    // TODO: Cancel via appointment service
    print('\n⏳ Feature coming soon...');
  }
}
