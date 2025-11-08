/// Manage Prescriptions UI
///
/// Provides CLI interface for prescription management operations for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../controllers/doctor/prescriptions_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';
import '../controllers/doctor/patients_controller.dart';

class ManagePrescriptions {
  final PrescriptionsController _controller;

  ManagePrescriptions() : _controller = PrescriptionsController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE PRESCRIPTIONS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Issue Prescription',
        'View My Prescriptions',
        'View Patient Prescriptions',
        'View Prescription Details',
        'Back to Doctor Dashboard',
      ]);

      switch (choice) {
        case 'Issue Prescription':
          _issuePrescription();
          TerminalUI.pauseAndClear();
          break;
        case 'View My Prescriptions':
          _viewMyPrescriptions();
          TerminalUI.pauseAndClear();
          break;
        case 'View Patient Prescriptions':
          _viewPatientPrescriptions();
          TerminalUI.pauseAndClear();
          break;
        case 'View Prescription Details':
          _viewPrescriptionDetails();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Doctor Dashboard':
          return;
      }
    }
  }

  void _issuePrescription() {
    print('\nISSUE PRESCRIPTION');
    print('-' * 50);
    try {
      // Select patient from list
      final patientsController = PatientsController();
      final patients = patientsController.getAllPatients();
      if (patients.isEmpty) {
        print('\nNo patients found.');
        return;
      }
      final patientOptions = formatCardOptions(patients);
      final chosenPatient = prompts.choose('Select a patient:', patientOptions);
      final pIdx = patientOptions.indexOf(chosenPatient!);
      final patientId = patients[pIdx].id;
      final medication = prompts.get('Medication Name:');
      final dosage = prompts.get('Dosage (e.g., 500mg):');
      final frequency = prompts.get('Frequency (e.g., 2x/day):');
      final durationStr = prompts.get('Duration Days:');
      final instructions = prompts.get('Instructions:');
      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final durationDays = int.tryParse(durationStr);
      if (durationDays == null || durationDays <= 0) {
        print('\nInvalid duration.');
        return;
      }

      final rx = _controller.issuePrescription(
        patientId: patientId.trim(),
        medicationName: medication.trim(),
        dosage: dosage.trim(),
        frequency: frequency.trim(),
        durationDays: durationDays,
        instructions: instructions.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (rx != null) {
        print('\nPrescription issued.');
        print(
          'ID: ${rx.id}  Patient: ${rx.patientId}  Med: ${rx.medicationName}',
        );
      } else {
        print('\nFailed to issue prescription. Ensure patient exists.');
      }
    } catch (e) {
      print('\nError: ${e.toString()}');
    }
  }

  void _viewPatientPrescriptions() {
    // Select patient from list
    final patientsController = PatientsController();
    final patients = patientsController.getAllPatients();
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }
    final patientOptions = formatCardOptions(patients);
    final chosenPatient = prompts.choose('Select a patient:', patientOptions);
    final pIdx = patientOptions.indexOf(chosenPatient!);
    final patientId = patients[pIdx].id;
    final list = _controller.getPatientPrescriptions(patientId.trim());
    final options = formatCardOptions(list);
    for (final line in options) {
      print(line);
    }
  }

  void _viewMyPrescriptions() {
    print('\nMY PRESCRIPTIONS');
    print('-' * 50);
    final list = _controller.getMyPrescriptions();
    if (list.isEmpty) {
      print('\nNo prescriptions.');
      return;
    }
    final options = formatCardOptions(list);
    for (final line in options) print(line);
  }

  void _viewPrescriptionDetails() {
    print('\nVIEW PRESCRIPTION DETAILS');
    print('-' * 50);
    final list = _controller.getMyPrescriptions();
    if (list.isEmpty) {
      print('\nNo prescriptions.');
      return;
    }
    final options = formatCardOptions(list);
    final chosen = prompts.choose('Select a prescription:', options);
    final idx = options.indexOf(chosen!);
    final rx = list[idx];
    final lines = formatCardOptions([rx]);
    for (final line in lines) {
      print(line);
    }
  }
}
