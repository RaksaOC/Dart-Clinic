/// Manage Patients UI
///
/// Provides CLI interface for patient management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/patient.dart';
import '../../domain/usecases/manager.dart' as manager_use_case;

class ManagePatients {
  final manager_use_case.Manager _manager;

  ManagePatients(this._manager);

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('👤 MANAGE PATIENTS');
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
          break;
        case 'View All Patients':
          _viewAllPatients();
          break;
        case 'Search Patients by Name':
          _searchPatientsByName();
          break;
        case 'Update Patient':
          _updatePatient();
          break;
        case 'Delete Patient':
          _deletePatient();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createPatient() {
    print('\n👤 CREATE PATIENT');
    print('-' * 50);

    try {
      final patientId = prompts.get('Patient ID (e.g., P001):');
      final name = prompts.get('Name:');
      final age = int.parse(prompts.get('Age:'));
      final gender = prompts.choose('Gender:', ['Male', 'Female', 'Other']);
      final phoneNumber = prompts.get('Phone Number:');
      final email = prompts.get('Email:');
      final address = prompts.get('Address:');

      final patient = _manager.createPatient(
        patientId: patientId.trim(),
        name: name.trim(),
        age: age,
        gender: gender ?? '',
        phoneNumber: phoneNumber.trim(),
        email: email.trim(),
        address: address.trim(),
      );

      if (patient != null) {
        print('\n✅ Patient created successfully!');
        print('Patient ID: ${patient.id}');
        print('Name: ${patient.name}');
      } else {
        print('\n❌ Failed to create patient. Patient ID might already exist.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewAllPatients() {
    print('\n👤 ALL PATIENTS');
    print('-' * 50);
    final patients = _manager.getAllPatients();
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }
    _displayPatients(patients);
  }

  void _searchPatientsByName() {
    print('\n🔍 SEARCH PATIENTS BY NAME');
    print('-' * 50);
    final name = prompts.get('Enter patient name to search:');
    final patients = _manager.searchPatientsByName(name.trim());
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }
    _displayPatients(patients);
  }

  void _displayPatients(List<PatientModel> patients) {
    print(
      '\n${'ID'.padRight(8)} ${'Name'.padRight(25)} ${'Age'.padRight(6)} ${'Gender'.padRight(8)} ${'Email'.padRight(25)}',
    );
    print('-' * 80);
    for (final patient in patients) {
      print(
        '${patient.id.padRight(8)} ${patient.name.padRight(25)} ${patient.age.toString().padRight(6)} ${patient.gender.padRight(8)} ${patient.email.padRight(25)}',
      );
    }
  }

  void _updatePatient() {
    print('\n✏️  UPDATE PATIENT');
    print('-' * 50);
    final patientId = prompts.get('Enter Patient ID to update:');
    final patient = _manager.getPatientById(patientId.trim());

    if (patient == null) {
      print('\n❌ Patient not found.');
      return;
    }

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
      print('\n✅ Patient updated successfully!');
    } else {
      print('\n❌ Failed to update patient.');
    }
  }

  void _deletePatient() {
    print('\n🗑️  DELETE PATIENT');
    print('-' * 50);
    final patientId = prompts.get('Enter Patient ID to delete:');
    final patient = _manager.getPatientById(patientId.trim());

    if (patient == null) {
      print('\n❌ Patient not found.');
      return;
    }

    // Check if patient is admitted
    final activeAdmission = _manager.getActiveAdmissionByPatientId(
      patientId.trim(),
    );
    if (activeAdmission != null) {
      print(
        '\n❌ Cannot delete patient. Patient is currently admitted to a room.',
      );
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to delete this patient? (y/n)',
    );
    if (confirm) {
      if (_manager.deletePatient(patientId.trim())) {
        print('\n✅ Patient deleted successfully!');
      } else {
        print('\n❌ Failed to delete patient.');
      }
    }
  }
}
