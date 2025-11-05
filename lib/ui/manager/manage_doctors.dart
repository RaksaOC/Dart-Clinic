/// Manage Doctors UI
///
/// Provides CLI interface for doctor management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/doctor.dart';
import '../../domain/usecases/manager.dart';

class ManageDoctors {
  final Manager _manager;

  ManageDoctors() : _manager = Manager();

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('👨‍⚕️  MANAGE DOCTORS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Create Doctor',
        'View All Doctors',
        'Search Doctors by Name',
        'View Doctors by Specialization',
        'Update Doctor',
        'Delete Doctor',
        'Back to Main Menu',
      ]);

      switch (choice) {
        case 'Create Doctor':
          _createDoctor();
          break;
        case 'View All Doctors':
          _viewAllDoctors();
          break;
        case 'Search Doctors by Name':
          _searchDoctorsByName();
          break;
        case 'View Doctors by Specialization':
          _viewDoctorsBySpecialization();
          break;
        case 'Update Doctor':
          _updateDoctor();
          break;
        case 'Delete Doctor':
          _deleteDoctor();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createDoctor() {
    print('\n👨‍⚕️  CREATE DOCTOR');
    print('-' * 50);

    try {
      final doctorId = prompts.get('Doctor ID (e.g., D001):');
      final name = prompts.get('Name:');
      final specialization = prompts.get('Specialization:');
      final phoneNumber = prompts.get('Phone Number:');
      final email = prompts.get('Email:');
      final address = prompts.get('Address:');
      final age = int.parse(prompts.get('Age:'));
      final gender = prompts.choose('Gender:', ['Male', 'Female', 'Other']);
      final password = prompts.get('Password:');

      final doctor = _manager.createDoctor(
        doctorId: doctorId.trim(),
        name: name.trim(),
        specialization: specialization.trim(),
        phoneNumber: phoneNumber.trim(),
        email: email.trim(),
        address: address.trim(),
        age: age,
        gender: gender ?? '',
        password: password,
      );

      if (doctor != null) {
        print('\n✅ Doctor created successfully!');
        print('Doctor ID: ${doctor.id}');
        print('Name: ${doctor.name}');
        print('Specialization: ${doctor.specialization}');
      } else {
        print('\n❌ Failed to create doctor. Doctor ID might already exist.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewAllDoctors() {
    print('\n👨‍⚕️  ALL DOCTORS');
    print('-' * 50);
    final doctors = _manager.getAllDoctors();
    if (doctors.isEmpty) {
      print('\nNo doctors found.');
      return;
    }
    _displayDoctors(doctors);
  }

  void _searchDoctorsByName() {
    print('\n🔍 SEARCH DOCTORS BY NAME');
    print('-' * 50);
    final name = prompts.get('Enter doctor name to search:');
    final doctors = _manager.searchDoctorsByName(name.trim());
    if (doctors.isEmpty) {
      print('\nNo doctors found.');
      return;
    }
    _displayDoctors(doctors);
  }

  void _viewDoctorsBySpecialization() {
    print('\n🔍 VIEW DOCTORS BY SPECIALIZATION');
    print('-' * 50);
    final specialization = prompts.get('Enter specialization:');
    final doctors = _manager.getDoctorsBySpecialization(specialization.trim());
    if (doctors.isEmpty) {
      print('\nNo doctors found with this specialization.');
      return;
    }
    _displayDoctors(doctors);
  }

  void _displayDoctors(List<DoctorModel> doctors) {
    print(
      '\n${'ID'.padRight(8)} ${'Name'.padRight(25)} ${'Specialization'.padRight(20)} ${'Email'.padRight(25)}',
    );
    print('-' * 90);
    for (final doctor in doctors) {
      print(
        '${doctor.id.padRight(8)} ${doctor.name.padRight(25)} ${doctor.specialization.padRight(20)} ${doctor.email.padRight(25)}',
      );
    }
  }

  void _updateDoctor() {
    print('\n✏️  UPDATE DOCTOR');
    print('-' * 50);
    final doctorId = prompts.get('Enter Doctor ID to update:');
    final doctor = _manager.getDoctorById(doctorId.trim());

    if (doctor == null) {
      print('\n❌ Doctor not found.');
      return;
    }

    print('\nCurrent Doctor Details:');
    print('Name: ${doctor.name}');
    print('Specialization: ${doctor.specialization}');
    print('Email: ${doctor.email}');
    print('Phone: ${doctor.phoneNumber}');
    print('Address: ${doctor.address}');

    final newName = prompts.get('New Name (or press Enter to keep):');
    final newSpecialization = prompts.get(
      'New Specialization (or press Enter to keep):',
    );
    final newPhone = prompts.get('New Phone Number (or press Enter to keep):');
    final newEmail = prompts.get('New Email (or press Enter to keep):');
    final newAddress = prompts.get('New Address (or press Enter to keep):');

    final updatedDoctor = DoctorModel(
      id: doctor.id,
      name: newName.trim().isEmpty ? doctor.name : newName.trim(),
      specialization: newSpecialization.trim().isEmpty
          ? doctor.specialization
          : newSpecialization.trim(),
      phoneNumber: newPhone.trim().isEmpty
          ? doctor.phoneNumber
          : newPhone.trim(),
      email: newEmail.trim().isEmpty ? doctor.email : newEmail.trim(),
      address: newAddress.trim().isEmpty ? doctor.address : newAddress.trim(),
      age: doctor.age,
      gender: doctor.gender,
      password: doctor.password,
    );

    if (_manager.updateDoctor(updatedDoctor)) {
      print('\n✅ Doctor updated successfully!');
    } else {
      print('\n❌ Failed to update doctor.');
    }
  }

  void _deleteDoctor() {
    print('\n🗑️  DELETE DOCTOR');
    print('-' * 50);
    final doctorId = prompts.get('Enter Doctor ID to delete:');
    final doctor = _manager.getDoctorById(doctorId.trim());

    if (doctor == null) {
      print('\n❌ Doctor not found.');
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to delete this doctor? (y/n)',
    );
    if (confirm) {
      if (_manager.deleteDoctor(doctorId.trim())) {
        print('\n✅ Doctor deleted successfully!');
      } else {
        print('\n❌ Failed to delete doctor.');
      }
    }
  }
}
