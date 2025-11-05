/// Manage Prescriptions UI
///
/// Provides CLI interface for prescription management operations for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/prescription.dart';
import '../../domain/controllers/doctor/prescriptions_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';

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
          _displayPrescriptions(_controller.getMyPrescriptions());
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
      final patientId = prompts.get('Patient ID:');
      final medication = prompts.get('Medication Name:');
      final dosage = prompts.get('Dosage (e.g., 500mg):');
      final frequency = prompts.get('Frequency (e.g., 2x/day):');
      final durationStr = prompts.get('Duration Days:');
      final instructions = prompts.get('Instructions:');
      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final durationDays = int.tryParse(durationStr);
      if (durationDays == null || durationDays <= 0) {
        print('\n❌ Invalid duration.');
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
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewPatientPrescriptions() {
    final patientId = prompts.get('Patient ID:');
    final list = _controller.getPatientPrescriptions(patientId.trim());
    _displayPrescriptions(list);
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
    _displayPrescriptions([rx]);
  }

  void _displayPrescriptions(List<PrescriptionModel> list) {
    if (list.isEmpty) {
      print('\nNo prescriptions.');
      return;
    }
    print(
      '\n${'ID'.padRight(10)} ${'Patient'.padRight(10)} ${'Medication'.padRight(20)} ${'Duration'.padRight(10)}',
    );
    print('-' * 70);
    for (final p in list) {
      print(
        '${p.id.padRight(10)} ${p.patientId.padRight(10)} ${p.medicationName.padRight(20)} ${p.durationDays.toString().padRight(10)}',
      );
    }
  }
}
