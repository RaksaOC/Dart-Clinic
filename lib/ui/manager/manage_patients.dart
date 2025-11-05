/// Manage Patients UI
///
/// Provides CLI interface for patient management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/patient.dart';
import '../../domain/controllers/manager/patients_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';

class ManagePatients {
  final PatientsController _manager;

  ManagePatients() : _manager = PatientsController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE PATIENTS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Create Patient',
        'View All Patients',
        'Search Patients by Name',
        'Update Patient',
        'Delete Patient',
        'Back to Main Menu',
      ]);

      switch (choice) {
        case 'Create Patient':
          _createPatient();
          TerminalUI.pauseAndClear();
          break;
        case 'View All Patients':
          _viewAllPatients();
          TerminalUI.pauseAndClear();
          break;
        case 'Update Patient':
          _updatePatient();
          TerminalUI.pauseAndClear();
          break;
        case 'Delete Patient':
          _deletePatient();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createPatient() {
    print('\nCREATE PATIENT');
    print('-' * 50);

    try {
      final name = prompts.get('Name:');
      final age = int.parse(prompts.get('Age:'));
      final gender = prompts.choose('Gender:', ['Male', 'Female', 'Other']);
      final phoneNumber = prompts.get('Phone Number:');
      final email = prompts.get('Email:');
      final address = prompts.get('Address:');

      final patient = _manager.createPatient(
        name: name.trim(),
        age: age,
        gender: gender ?? '',
        phoneNumber: phoneNumber.trim(),
        email: email.trim(),
        address: address.trim(),
      );

      if (patient != null) {
        print('\nPatient created successfully.');
        print('Patient ID: ${patient.id}');
        print('Name: ${patient.name}');
      } else {
        print('\nFailed to create patient. Patient ID might already exist.');
      }
    } catch (e) {
      print('\nError: ${e.toString()}');
    }
  }

  void _viewAllPatients() {
    print('\nALL PATIENTS');
    print('-' * 50);
    final patients = _manager.getAllPatients();
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }
    final options = formatCardOptions(patients);
    for (final line in options) {
      print(line);
    }
  }

  void _updatePatient() {
    print('\nUPDATE PATIENT');
    print('-' * 50);
    final patients = _manager.getAllPatients();
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }

    final options = formatCardOptions(patients);
    final chosen = prompts.choose('Select a patient to update:', options);
    final idx = options.indexOf(chosen!);
    final patient = patients[idx];

    print('\nCurrent Patient Details:');
    print('Name: ${patient.name}');
    print('Age: ${patient.age}');
    print('Gender: ${patient.gender}');
    print('Email: ${patient.email}');
    print('Phone: ${patient.phoneNumber}');
    print('Address: ${patient.address}');

    final newName = prompts.get('New Name (or press Enter to keep):');
    final newAgeStr = prompts.get('New Age (or press Enter to keep):');
    final newPhone = prompts.get('New Phone Number (or press Enter to keep):');
    final newEmail = prompts.get('New Email (or press Enter to keep):');
    final newAddress = prompts.get('New Address (or press Enter to keep):');

    final updatedPatient = PatientModel(
      id: patient.id,
      name: newName.trim().isEmpty ? patient.name : newName.trim(),
      age: newAgeStr.trim().isEmpty ? patient.age : int.parse(newAgeStr),
      gender: patient.gender,
      phoneNumber: newPhone.trim().isEmpty
          ? patient.phoneNumber
          : newPhone.trim(),
      email: newEmail.trim().isEmpty ? patient.email : newEmail.trim(),
      address: newAddress.trim().isEmpty ? patient.address : newAddress.trim(),
    );

    if (_manager.updatePatient(updatedPatient)) {
      print('\nPatient updated successfully.');
    } else {
      print('\nFailed to update patient.');
    }
  }

  void _deletePatient() {
    print('\nDELETE PATIENT');
    print('-' * 50);
    final patients = _manager.getAllPatients();
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }

    final options = formatCardOptions(patients);
    final chosen = prompts.choose('Select a patient to delete:', options);
    final idx = options.indexOf(chosen!);
    final patient = patients[idx];

    // Admission check is handled inside controller deletePatient()

    final confirm = prompts.getBool(
      'Are you sure you want to delete this patient? (y/n)',
    );
    if (confirm) {
      if (_manager.deletePatient(patient.id)) {
        print('\nPatient deleted successfully.');
      } else {
        print('\nFailed to delete patient.');
      }
    }
  }
}
