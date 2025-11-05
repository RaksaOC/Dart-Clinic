/// Search Patients UI
///
/// Provides CLI interface for searching and viewing patients for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/patient.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/prescription.dart';
import '../../domain/controllers/doctor/patients_controller.dart';
import '../../domain/controllers/doctor/appointments_controller.dart';
import '../../domain/controllers/doctor/prescriptions_controller.dart';
import 'package:dart_clinic/utils/terminal.dart';
import 'package:dart_clinic/utils/formatter.dart';

class SearchPatients {
  final PatientsController _patients;
  final AppointmentsController _appointments;
  final PrescriptionsController _prescriptions;

  SearchPatients()
    : _patients = PatientsController(),
      _appointments = AppointmentsController(),
      _prescriptions = PrescriptionsController();

  void display() {
    TerminalUI.clearScreen();
    print('\n' + '=' * 50);
    print('PATIENT DIRECTORY');
    print('=' * 50);

    final patients = _patients.getAllPatients();
    if (patients.isEmpty) {
      print('\nNo patients found.');
      return;
    }

    final lines = formatCardOptions(patients);
    for (final line in lines) {
      print(line);
    }
  }
}
