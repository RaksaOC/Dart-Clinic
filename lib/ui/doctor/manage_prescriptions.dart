/// Manage Prescriptions UI
///
/// Provides CLI interface for prescription management operations for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/prescription.dart';
import '../../domain/usecases/doctor.dart';

class ManagePrescriptions {
  final Doctor _doctor;

  ManagePrescriptions() : _doctor = Doctor();

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('💊 MANAGE PRESCRIPTIONS');
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
          break;
        case 'View My Prescriptions':
          _displayPrescriptions(_doctor.getMyPrescriptions());
          break;
        case 'View Patient Prescriptions':
          _viewPatientPrescriptions();
          break;
        case 'View Prescription Details':
          _viewPrescriptionDetails();
          break;
        case 'Back to Doctor Dashboard':
          return;
      }
    }
  }

  void _issuePrescription() {
    print('\n📝 ISSUE PRESCRIPTION');
    print('-' * 50);
    try {
      final id = prompts.get('Prescription ID (e.g., RX001):');
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

      final rx = _doctor.issuePrescription(
        prescriptionId: id.trim(),
        patientId: patientId.trim(),
        medicationName: medication.trim(),
        dosage: dosage.trim(),
        frequency: frequency.trim(),
        durationDays: durationDays,
        instructions: instructions.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (rx != null) {
        print('\n✅ Prescription issued!');
        print(
          'ID: ${rx.id}  Patient: ${rx.patientId}  Med: ${rx.medicationName}',
        );
      } else {
        print('\n❌ Failed to issue prescription. Ensure patient exists.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewPatientPrescriptions() {
    final patientId = prompts.get('Patient ID:');
    final list = _doctor.getPatientPrescriptions(patientId.trim());
    _displayPrescriptions(list);
  }

  void _viewPrescriptionDetails() {
    print('\n🔎 VIEW PRESCRIPTION DETAILS');
    print('-' * 50);
    final id = prompts.get('Prescription ID:');
    final rx = _doctor.getPrescriptionById(id.trim());
    if (rx == null) {
      print('\n❌ Prescription not found for you.');
      return;
    }
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
