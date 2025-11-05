import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/services/admission_service.dart';
import 'package:dart_clinic/services/appointment_service.dart';
import 'package:dart_clinic/services/doctor_service.dart';
import 'package:dart_clinic/services/manager_service.dart';
import 'package:dart_clinic/services/patient_service.dart';
import 'package:dart_clinic/services/prescription_service.dart';
import 'package:dart_clinic/services/room_service.dart';
import 'package:dart_clinic/services/session_service.dart';

void main() {
  final originalDir = Directory.current;

  setUpAll(() {
    final libDir = Directory(p.join(originalDir.path, 'lib'));
    if (libDir.existsSync()) {
      Directory.current = libDir.path;
    }
  });

  tearDownAll(() {
    Directory.current = originalDir.path;
  });

  setUp(() {
    SessionService().logout();
  });

  group('SessionService', () {
    test('loginDoctor authenticates valid credentials', () {
      final session = SessionService();
      final doctor = session.loginDoctor('qw', 'qw');

      expect(doctor, isNotNull);
      expect(session.currentDoctor?.id, equals('D001'));
      expect(session.currentManager, isNull);
    });

    test('loginDoctor rejects invalid credentials', () {
      final session = SessionService();
      final doctor = session.loginDoctor('invalid@example.com', 'badpass');

      expect(doctor, isNull);
      expect(session.currentDoctor, isNull);
    });

    test('logging in as manager clears doctor session', () {
      final session = SessionService();

      final manager = session.loginManager(
        'vannak.sok@clinic.kh',
        'manager123',
      );

      expect(manager, isNotNull);
      expect(session.currentDoctor, isNull);
      expect(session.currentManager?.id, equals('M001'));
    });
  });

  group('AppointmentService', () {
    test('creates and persists a scheduled appointment', () {
      SessionService().loginDoctor('qw', 'qw');
      final appointmentService = AppointmentService();

      final futureSlot = DateTime.now().add(const Duration(days: 2));
      final created = appointmentService.createAppointment(
        patientId: 'P002',
        appointmentDateTime: futureSlot,
        notes: 'Routine check-up',
      );

      expect(created, isNotNull);

      final stored = appointmentService.getById(created!.id);
      expect(stored, isNotNull);
      expect(stored!.status, AppointmentStatus.scheduled);
      expect(stored.patientId, equals('P002'));
    });

    test('rejects double-booking the same timeslot for the doctor', () {
      SessionService().loginDoctor('qw', 'qw');
      final appointmentService = AppointmentService();

      final conflictingSlot = DateTime.parse('2025-11-06T09:00:00.000Z');
      final created = appointmentService.createAppointment(
        patientId: 'P003',
        appointmentDateTime: conflictingSlot,
        notes: 'Should fail',
      );

      expect(created, isNull);
    });
  });

  group('PrescriptionService', () {
    test('issues a prescription and makes it discoverable', () {
      SessionService().loginDoctor('qw', 'qw');
      final prescriptionService = PrescriptionService();

      final issued = prescriptionService.issuePrescription(
        patientId: 'P003',
        medicationName: 'Ibuprofen',
        dosage: '200mg',
        frequency: '2x/day',
        durationDays: 7,
        instructions: 'After meals',
        notes: 'Pain management',
      );

      expect(issued, isNotNull);

      final myPrescriptions = prescriptionService.getMyPrescriptions();
      expect(myPrescriptions.map((rx) => rx.id), contains(issued!.id));

      final patientPrescriptions = prescriptionService.getPatientPrescriptions(
        'P003',
      );
      expect(patientPrescriptions.map((rx) => rx.id), contains(issued.id));
    });
  });

  group('AdmissionService', () {
    test('admits and discharges patient correctly', () {
      final admissionService = AdmissionService();

      final admission = admissionService.admitPatient(
        patientId: 'P002',
        roomId: 'R004',
        notes: 'Observation',
      );

      expect(admission, isNotNull);
      expect(admission!.status, AdmissionStatus.active);

      final discharged = admissionService.dischargePatient(admission.id);
      expect(discharged, isTrue);

      final updated = admissionService.getById(admission.id);
      expect(updated, isNotNull);
      expect(updated!.status, AdmissionStatus.discharged);
    });
  });

  group('RoomService', () {
    test('reports accurate availability stats', () {
      final service = RoomService();

      final stats = service.getOccupancyStats();
      expect(stats['totalRooms'], greaterThan(0));
      expect(stats.containsKey('availableRooms'), isTrue);
    });
  });

  group('DoctorService', () {
    test('creates and deletes doctors', () {
      final service = DoctorService();

      final created = service.createDoctor(
        name: 'Dr. Lina',
        specialization: 'Dermatology',
        phoneNumber: '+855-99-000-111',
        email: 'lina.derm@clinic.kh',
        address: 'Phnom Penh',
        age: 36,
        gender: 'Female',
        password: 'skinCare',
      );

      expect(created, isNotNull);
      final deleted = service.deleteDoctor(created!.id);
      expect(deleted, isTrue);
    });
  });

  group('ManagerService', () {
    test('creates and deletes manager', () {
      final service = ManagerService();

      final created = service.createManager(
        name: 'Chan Dara',
        email: 'chan.dara@clinic.kh',
        password: 'securePass',
        age: 30,
        gender: 'Male',
        phoneNumber: '+855-11-222-333',
        address: 'Battambang',
      );

      expect(created, isNotNull);
      final deleted = service.deleteManager(created!.id);
      expect(deleted, isTrue);
    });
  });

  group('PatientService', () {
    test('creates and deletes patient', () {
      final service = PatientService();

      final created = service.createPatient(
        name: 'Test Patient',
        age: 45,
        gender: 'Female',
        phoneNumber: '+855-77-888-999',
        email: 'test.patient@clinic.kh',
        address: 'Siem Reap',
      );

      expect(created, isNotNull);
      final deleted = service.deletePatient(created!.id);
      expect(deleted, isTrue);
    });
  });
}
