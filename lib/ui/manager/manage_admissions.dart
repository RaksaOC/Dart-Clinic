/// Manage Admissions UI
///
/// Provides CLI interface for admission management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/admission.dart';
import '../../domain/usecases/manager.dart';

class ManageAdmissions {
  final Manager _manager;

  ManageAdmissions() : _manager = Manager();

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('🛏️  MANAGE ADMISSIONS');
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
          break;
        case 'Discharge Patient':
          _dischargePatient();
          break;
        case 'View All Admissions':
          _viewAllAdmissions();
          break;
        case 'View Active Admissions':
          _viewActiveAdmissions();
          break;
        case 'View Patient Admission History':
          _viewPatientAdmissionHistory();
          break;
        case 'View Room Admission History':
          _viewRoomAdmissionHistory();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _admitPatient() {
    print('\n🛏️  ADMIT PATIENT TO ROOM');
    print('-' * 50);

    // List available rooms
    final availableRooms = _manager.getAvailableRooms();
    if (availableRooms.isEmpty) {
      print('\n❌ No available rooms.');
      return;
    }

    // List patients
    final patients = _manager.getAllPatients();
    if (patients.isEmpty) {
      print('\n❌ No patients found.');
      return;
    }

    try {
      final admissionId = prompts.get('Admission ID (e.g., A001):');
      final patientId = prompts.get('Patient ID:');
      final patient = _manager.getPatientById(patientId.trim());

      if (patient == null) {
        print('\n❌ Patient not found.');
        return;
      }

      // Check if patient is already admitted
      final activeAdmission = _manager.getActiveAdmissionByPatientId(
        patientId.trim(),
      );
      if (activeAdmission != null) {
        print('\n❌ Patient is already admitted to a room.');
        return;
      }

      print('\nAvailable Rooms:');
      _displayRooms(availableRooms);

      final roomId = prompts.get('Room ID:');
      final room = _manager.getRoomById(roomId.trim());

      if (room == null) {
        print('\n❌ Room not found.');
        return;
      }

      if (room.isOccupied) {
        print('\n❌ Room is already occupied.');
        return;
      }

      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final admission = _manager.admitPatient(
        admissionId: admissionId.trim(),
        patientId: patientId.trim(),
        roomId: roomId.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (admission != null) {
        print('\n✅ Patient admitted successfully!');
        print('Admission ID: ${admission.id}');
        print('Patient: ${patient.name}');
        print('Room: ${room.roomNumber}');
        print('Admission Date: ${admission.admissionDate}');
      } else {
        print('\n❌ Failed to admit patient.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _displayRooms(List rooms) {
    print(
      '\n${'ID'.padRight(8)} ${'Room #'.padRight(10)} ${'Type'.padRight(12)} ${'Rate'.padRight(10)}',
    );
    print('-' * 50);
    for (final room in rooms) {
      print(
        '${room.id.padRight(8)} ${room.roomNumber.padRight(10)} ${room.roomType.padRight(12)} \$${room.dailyRate.toStringAsFixed(2).padLeft(8)}',
      );
    }
  }

  void _dischargePatient() {
    print('\n🏥 DISCHARGE PATIENT');
    print('-' * 50);

    final activeAdmissions = _manager.getActiveAdmissions();
    if (activeAdmissions.isEmpty) {
      print('\n❌ No active admissions.');
      return;
    }

    print('\nActive Admissions:');
    print(
      '${'ID'.padRight(10)} ${'Patient ID'.padRight(12)} ${'Room ID'.padRight(10)} ${'Admission Date'.padRight(20)}',
    );
    print('-' * 60);
    for (final admission in activeAdmissions) {
      final patient = _manager.getPatientById(admission.patientId);
      final patientName = patient?.name ?? admission.patientId;
      print(
        '${admission.id.padRight(10)} ${patientName.padRight(12)} ${admission.roomId.padRight(10)} ${admission.admissionDate.toString().padRight(20)}',
      );
    }

    final admissionId = prompts.get('Enter Admission ID to discharge:');
    final admission = _manager.getAdmissionById(admissionId.trim());

    if (admission == null ||
        admission.status.toString().contains('discharged')) {
      print('\n❌ Admission not found or already discharged.');
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to discharge this patient? (y/n)',
    );
    if (confirm) {
      if (_manager.dischargePatient(admissionId.trim())) {
        print('\n✅ Patient discharged successfully!');
      } else {
        print('\n❌ Failed to discharge patient.');
      }
    }
  }

  void _viewAllAdmissions() {
    print('\n📋 ALL ADMISSIONS');
    print('-' * 50);
    final admissions = _manager.getAllAdmissions();
    if (admissions.isEmpty) {
      print('\nNo admissions found.');
      return;
    }
    _displayAdmissions(admissions);
  }

  void _viewActiveAdmissions() {
    print('\n✅ ACTIVE ADMISSIONS');
    print('-' * 50);
    final admissions = _manager.getActiveAdmissions();
    if (admissions.isEmpty) {
      print('\nNo active admissions.');
      return;
    }
    _displayAdmissions(admissions);
  }

  void _viewPatientAdmissionHistory() {
    print('\n📋 PATIENT ADMISSION HISTORY');
    print('-' * 50);
    final patientId = prompts.get('Enter Patient ID:');
    final admissions = _manager.getAdmissionsByPatientId(patientId.trim());
    if (admissions.isEmpty) {
      print('\nNo admission history found for this patient.');
      return;
    }
    _displayAdmissions(admissions);
  }

  void _viewRoomAdmissionHistory() {
    print('\n📋 ROOM ADMISSION HISTORY');
    print('-' * 50);
    final roomId = prompts.get('Enter Room ID:');
    final admissions = _manager.getAdmissionsByRoomId(roomId.trim());
    if (admissions.isEmpty) {
      print('\nNo admission history found for this room.');
      return;
    }
    _displayAdmissions(admissions);
  }

  void _displayAdmissions(List<AdmissionModel> admissions) {
    print(
      '\n${'ID'.padRight(10)} ${'Patient ID'.padRight(12)} ${'Room ID'.padRight(10)} ${'Status'.padRight(12)} ${'Admission Date'.padRight(20)} ${'Discharge Date'.padRight(20)}',
    );
    print('-' * 100);
    for (final admission in admissions) {
      final dischargeDate = admission.dischargeDate?.toString() ?? 'N/A';
      print(
        '${admission.id.padRight(10)} ${admission.patientId.padRight(12)} ${admission.roomId.padRight(10)} ${admission.status.name.padRight(12)} ${admission.admissionDate.toString().padRight(20)} ${dischargeDate.padRight(20)}',
      );
    }
  }
}
