/// Search Patients UI
///
/// Provides CLI interface for searching and viewing patients for doctors.
library;

import '../controllers/doctor/patients_controller.dart';
import 'package:dart_clinic/utils/terminal.dart';
import 'package:dart_clinic/utils/formatter.dart';

class SearchPatients {
  final PatientsController _patients;

  SearchPatients() : _patients = PatientsController();

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
