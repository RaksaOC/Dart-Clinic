/// Manage Doctors UI
///
/// Provides CLI interface for doctor management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/doctor.dart';
import '../../domain/controllers/manager/doctors_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';

class ManageDoctors {
  final DoctorsController _manager;

  ManageDoctors() : _manager = DoctorsController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE DOCTORS');
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
          TerminalUI.pauseAndClear();
          break;
        case 'View All Doctors':
          _viewAllDoctors();
          TerminalUI.pauseAndClear();
          break;
        case 'Search Doctors by Name':
          _searchDoctorsByName();
          TerminalUI.pauseAndClear();
          break;
        case 'View Doctors by Specialization':
          _viewDoctorsBySpecialization();
          TerminalUI.pauseAndClear();
          break;
        case 'Update Doctor':
          _updateDoctor();
          TerminalUI.pauseAndClear();
          break;
        case 'Delete Doctor':
          _deleteDoctor();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createDoctor() {
    print('\nCREATE DOCTOR');
    print('-' * 50);

    try {
      final name = prompts.get('Name:');
      final specialization = prompts.get('Specialization:');
      final phoneNumber = prompts.get('Phone Number:');
      final email = prompts.get('Email:');
      final address = prompts.get('Address:');
      final age = int.parse(prompts.get('Age:'));
      final gender = prompts.choose('Gender:', ['Male', 'Female', 'Other']);
      final password = prompts.get('Password:');

      final doctor = _manager.createDoctor(
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
        print('\nDoctor created successfully.');
        print('Doctor ID: ${doctor.id}');
        print('Name: ${doctor.name}');
        print('Specialization: ${doctor.specialization}');
      } else {
        print('\nFailed to create doctor. Doctor ID might already exist.');
      }
    } catch (e) {
      print('\nError: ${e.toString()}');
    }
  }

  void _viewAllDoctors() {
    print('\nALL DOCTORS');
    print('-' * 50);
    final doctors = _manager.getAllDoctors();
    if (doctors.isEmpty) {
      print('\nNo doctors found.');
      return;
    }
    final options = formatCardOptions(doctors);
    for (final line in options) {
      print(line);
    }
  }

  void _searchDoctorsByName() {
    print('\nSEARCH DOCTORS BY NAME');
    print('-' * 50);
    final name = prompts.get('Enter doctor name to search:');
    final doctors = _manager.searchDoctorsByName(name.trim());
    if (doctors.isEmpty) {
      print('\nNo doctors found.');
      return;
    }
    final options = formatCardOptions(doctors);
    for (final line in options) {
      print(line);
    }
  }

  void _viewDoctorsBySpecialization() {
    print('\nVIEW DOCTORS BY SPECIALIZATION');
    print('-' * 50);
    final specialization = prompts.get('Enter specialization:');
    final doctors = _manager.getDoctorsBySpecialization(specialization.trim());
    if (doctors.isEmpty) {
      print('\nNo doctors found with this specialization.');
      return;
    }
    final options = formatCardOptions(doctors);
    for (final line in options) {
      print(line);
    }
  }

  void _updateDoctor() {
    print('\nUPDATE DOCTOR');
    print('-' * 50);
    final doctors = _manager.getAllDoctors();
    if (doctors.isEmpty) {
      print('\nNo doctors found.');
      return;
    }

    final options = formatCardOptions(doctors);
    final chosen = prompts.choose('Select a doctor to update:', options);
    final idx = options.indexOf(chosen!);
    final doctor = doctors[idx];

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
      print('\nDoctor updated successfully.');
    } else {
      print('\nFailed to update doctor.');
    }
  }

  void _deleteDoctor() {
    print('\nDELETE DOCTOR');
    print('-' * 50);
    final doctors = _manager.getAllDoctors();
    if (doctors.isEmpty) {
      print('\nNo doctors found.');
      return;
    }

    final options = formatCardOptions(doctors);
    final chosen = prompts.choose('Select a doctor to delete:', options);
    final idx = options.indexOf(chosen!);
    final doctor = doctors[idx];

    final confirm = prompts.getBool(
      'Are you sure you want to delete this doctor? (y/n)',
    );
    if (confirm) {
      if (_manager.deleteDoctor(doctor.id)) {
        print('\nDoctor deleted successfully.');
      } else {
        print('\nFailed to delete doctor.');
      }
    }
  }
}
