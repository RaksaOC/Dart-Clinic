/// Search Patients UI
///
/// Provides CLI interface for searching and viewing patients for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/patient.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/prescription.dart';
import '../../domain/usecases/doctor.dart';

class SearchPatients {
  final Doctor _doctor;

  SearchPatients() : _doctor = Doctor();

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('🔎 SEARCH PATIENTS');
      print('=' * 50);

      final choice = prompts.choose('Choose an option:', [
        'Search by Name',
        'Search by ID',
        'Back to Doctor Dashboard',
      ]);

      switch (choice) {
        case 'Search by Name':
          _searchByName();
          break;
        case 'Search by ID':
          _searchById();
          break;
        case 'Back to Doctor Dashboard':
          return;
      }
    }
  }

  void _searchByName() {
    final name = prompts.get('Enter name:');
    final results = _doctor.searchPatientsByName(name.trim());
    _displayPatients(results);
  }

  void _searchById() {
    final id = prompts.get('Enter patient ID:');
    final patient = _doctor.getPatientById(id.trim());
    if (patient == null) {
      print('\n❌ Patient not found.');
      return;
    }
    _displayPatients([patient]);

    while (true) {
      final choice = prompts.choose('Actions:', [
        'View Patient Appointments',
        'View Patient Prescriptions',
        'Back',
      ]);
      if (choice == 'Back') return;
      if (choice == 'View Patient Appointments') {
        final appts = _doctor.getPatientAppointments(patient.id);
        _displayAppointments(appts);
      }
      if (choice == 'View Patient Prescriptions') {
        final rxs = _doctor.getPatientPrescriptions(patient.id);
        _displayPrescriptions(rxs);
      }
    }
  }

  void _displayPatients(List<PatientModel> patients) {
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }
    print(
      '\n${'ID'.padRight(8)} ${'Name'.padRight(25)} ${'Age'.padRight(6)} ${'Gender'.padRight(8)} ${'Email'.padRight(25)}',
    );
    print('-' * 80);
    for (final p in patients) {
      print(
        '${p.id.padRight(8)} ${p.name.padRight(25)} ${p.age.toString().padRight(6)} ${p.gender.padRight(8)} ${p.email.padRight(25)}',
      );
    }
  }

  void _displayAppointments(List<AppointmentModel> appts) {
    if (appts.isEmpty) {
      print('\nNo appointments.');
      return;
    }
    print(
      '\n${'ID'.padRight(10)} ${'Doctor'.padRight(10)} ${'When'.padRight(20)} ${'Status'.padRight(12)}',
    );
    print('-' * 70);
    for (final a in appts) {
      print(
        '${a.id.padRight(10)} ${a.doctorId.padRight(10)} ${a.appointmentDateTime.toString().padRight(20)} ${a.status.name.padRight(12)}',
      );
    }
  }

  void _displayPrescriptions(List<PrescriptionModel> list) {
    if (list.isEmpty) {
      print('\nNo prescriptions.');
      return;
    }
    print(
      '\n${'ID'.padRight(10)} ${'Doctor'.padRight(10)} ${'Medication'.padRight(20)} ${'Duration'.padRight(10)}',
    );
    print('-' * 70);
    for (final p in list) {
      print(
        '${p.id.padRight(10)} ${p.doctorId.padRight(10)} ${p.medicationName.padRight(20)} ${p.durationDays.toString().padRight(10)}',
      );
    }
  }
}
