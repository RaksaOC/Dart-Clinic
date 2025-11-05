/// Manage Admissions UI
///
/// Provides CLI interface for admission management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/controllers/manager/admissions_controller.dart';
import '../../domain/controllers/manager/rooms_controller.dart';
import '../../domain/controllers/manager/patients_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';

class ManageAdmissions {
  final AdmissionsController _manager;
  final RoomsController _rooms;
  final PatientsController _patients;

  ManageAdmissions()
    : _manager = AdmissionsController(),
      _rooms = RoomsController(),
      _patients = PatientsController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE ADMISSIONS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Admit Patient to Room',
        'Discharge Patient',
        'View All Admissions',
        'View Active Admissions',
        'View Patient Admission History',
        'View Room Admission History',
        'Back to Main Menu',
      ]);

      switch (choice) {
        case 'Admit Patient to Room':
          _admitPatient();
          TerminalUI.pauseAndClear();
          break;
        case 'Discharge Patient':
          _dischargePatient();
          TerminalUI.pauseAndClear();
          break;
        case 'View All Admissions':
          _viewAllAdmissions();
          TerminalUI.pauseAndClear();
          break;
        case 'View Active Admissions':
          _viewActiveAdmissions();
          TerminalUI.pauseAndClear();
          break;
        case 'View Patient Admission History':
          _viewPatientAdmissionHistory();
          TerminalUI.pauseAndClear();
          break;
        case 'View Room Admission History':
          _viewRoomAdmissionHistory();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _admitPatient() {
    print('\nADMIT PATIENT TO ROOM');
    print('-' * 50);

    // List available rooms
    final availableRooms = _rooms.getAvailableRooms();
    if (availableRooms.isEmpty) {
      print('\n❌ No available rooms.');
      return;
    }

    // List patients
    final patients = _patients.getAllPatients();
    if (patients.isEmpty) {
      print('\n❌ No patients found.');
      return;
    }

    try {
      final patientOptions = formatCardOptions(patients);
      final chosenPatient = prompts.choose('Select a patient:', patientOptions);
      final pIdx = patientOptions.indexOf(chosenPatient!);
      final patient = patients[pIdx];

      // Check if patient is already admitted
      final activeAdmission = _manager.getActiveByPatientId(patient.id);
      if (activeAdmission != null) {
        print('\n❌ Patient is already admitted to a room.');
        return;
      }

      print('\nAvailable Rooms:');
      final options = formatCardOptions(availableRooms);
      for (final line in options) {
        print(line);
      }

      final chosenRoom = prompts.choose('Select a room:', options);
      final rIdx = options.indexOf(chosenRoom!);
      final room = availableRooms[rIdx];

      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final admission = _manager.admitPatient(
        patientId: patient.id,
        roomId: room.id,
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (admission != null) {
        print('\nPatient admitted successfully.');
        print('Admission ID: ${admission.id}');
        print('Patient: ${patient.name}');
        print('Room: ${room.roomNumber}');
        print('Admission Date: ${admission.admissionDate}');
      } else {
        print('\nFailed to admit patient.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _dischargePatient() {
    print('\nDISCHARGE PATIENT');
    print('-' * 50);

    final activeAdmissions = _manager.getActiveAdmissions();
    if (activeAdmissions.isEmpty) {
      print('\nNo active admissions.');
      return;
    }

    final options = formatCardOptions(activeAdmissions);
    for (final line in options) {
      print(line);
    }

    final chosen = prompts.choose('Select an admission to discharge:', options);
    final idx = options.indexOf(chosen!);
    final admission = activeAdmissions[idx];

    final confirm = prompts.getBool(
      'Are you sure you want to discharge this patient? (y/n)',
    );
    if (confirm) {
      if (_manager.dischargePatient(admission.id)) {
        print('\nPatient discharged successfully.');
      } else {
        print('\nFailed to discharge patient.');
      }
    }
  }

  void _viewAllAdmissions() {
    print('\nALL ADMISSIONS');
    print('-' * 50);
    final admissions = _manager.getAllAdmissions();
    if (admissions.isEmpty) {
      print('\nNo admissions found.');
      return;
    }
    final options = formatCardOptions(admissions);
    for (final line in options) {
      print(line);
    }
  }

  void _viewActiveAdmissions() {
    print('\nACTIVE ADMISSIONS');
    print('-' * 50);
    final admissions = _manager.getActiveAdmissions();
    if (admissions.isEmpty) {
      print('\nNo active admissions.');
      return;
    }
    final options = formatCardOptions(admissions);
    for (final line in options) {
      print(line);
    }
  }

  void _viewPatientAdmissionHistory() {
    print('\nPATIENT ADMISSION HISTORY');
    print('-' * 50);
    final patientId = prompts.get('Enter Patient ID:');
    final admissions = _manager.getAdmissionsByPatientId(patientId.trim());
    if (admissions.isEmpty) {
      print('\nNo admission history found for this patient.');
      return;
    }
    final options = formatCardOptions(admissions);
    for (final line in options) {
      print(line);
    }
  }

  void _viewRoomAdmissionHistory() {
    print('\nROOM ADMISSION HISTORY');
    print('-' * 50);
    final roomId = prompts.get('Enter Room ID:');
    final admissions = _manager.getAdmissionsByRoomId(roomId.trim());
    if (admissions.isEmpty) {
      print('\nNo admission history found for this room.');
      return;
    }
    final options = formatCardOptions(admissions);
    for (final line in options) {
      print(line);
    }
  }
}
