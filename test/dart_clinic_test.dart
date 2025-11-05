import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/domain/models/doctor.dart';
import 'package:dart_clinic/domain/models/manager.dart';
import 'package:dart_clinic/domain/models/patient.dart';
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

    test('logout clears active sessions', () {
      final session = SessionService();
      session.loginDoctor('qw', 'qw');

      session.logout();

      expect(session.currentDoctor, isNull);
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

    test('loginManager authenticates valid credentials', () {
      final session = SessionService();
      final manager = session.loginManager(
        'vannak.sok@clinic.kh',
        'manager123',
      );

      expect(manager, isNotNull);
      expect(session.currentManager?.id, equals('M001'));
    });
  });

  group('AppointmentService', () {
    test('requires login to create appointment', () {
      final appointmentService = AppointmentService();

      final created = appointmentService.createAppointment(
        patientId: 'P002',
        appointmentDateTime: DateTime.now().add(const Duration(days: 1)),
        notes: 'Should not be created',
      );

      expect(created, isNull);
    });

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

    test('retrieves appointments for patient', () {
      SessionService().loginDoctor('qw', 'qw');
      final appointmentService = AppointmentService();

      final patientAppointments = appointmentService.getPatientAppointments(
        'P001',
      );

      expect(patientAppointments.map((a) => a.id), contains('AP001'));
    });

    test('returns only logged-in doctor appointments', () {
      SessionService().loginDoctor('qw', 'qw');
      final appointmentService = AppointmentService();

      final myAppointments = appointmentService.getMyAppointments();

      expect(myAppointments, isNotEmpty);
      expect(myAppointments.every((a) => a.doctorId == 'D001'), isTrue);
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

    test('loads prescriptions for logged-in doctor', () {
      SessionService().loginDoctor('qw', 'qw');
      final prescriptionService = PrescriptionService();

      final myPrescriptions = prescriptionService.getMyPrescriptions();

      expect(myPrescriptions, isNotEmpty);
      expect(myPrescriptions.every((rx) => rx.doctorId == 'D001'), isTrue);
    });

    test('retrieves prescriptions for patient', () {
      final prescriptionService = PrescriptionService();

      final prescriptions = prescriptionService.getPatientPrescriptions('P001');

      expect(prescriptions.map((rx) => rx.id), contains('RX002'));
    });

    test('gets prescription by id for logged-in doctor', () {
      SessionService().loginDoctor('qw', 'qw');
      final prescriptionService = PrescriptionService();

      final rx = prescriptionService.getById('RX002');

      expect(rx, isNotNull);
      expect(rx!.patientId, equals('P001'));
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

    test('prevents admitting patient twice concurrently', () {
      final admissionService = AdmissionService();

      final first = admissionService.admitPatient(
        patientId: 'P003',
        roomId: 'R005',
        notes: 'Initial stay',
      );

      expect(first, isNotNull);

      final second = admissionService.admitPatient(
        patientId: 'P003',
        roomId: 'R006',
        notes: 'Should fail',
      );

      expect(second, isNull);

      if (first != null) {
        admissionService.dischargePatient(first.id);
      }
    });

    test('returns active admissions list', () {
      final admissionService = AdmissionService();

      final active = admissionService.getActiveAdmissions();

      expect(active, isNotEmpty);
      expect(active.any((a) => a.status == AdmissionStatus.active), isTrue);
    });

    test('fetch admission by id', () {
      final admissionService = AdmissionService();

      final admission = admissionService.getById('A001');

      expect(admission, isNotNull);
      expect(admission!.patientId, equals('P001'));
    });
  });

  group('RoomService', () {
    test('reports accurate availability stats', () {
      final service = RoomService();

      final stats = service.getOccupancyStats();
      expect(stats['totalRooms'], greaterThan(0));
      expect(stats.containsKey('availableRooms'), isTrue);
    });

    test('fetches room details by id', () {
      final service = RoomService();

      final room = service.getRoomById('R002');

      expect(room, isNotNull);
      expect(room!.roomNumber, equals('102'));
    });

    test('available rooms list matches occupancy status', () {
      final service = RoomService();

      final availableRooms = service.getAvailableRooms();

      expect(availableRooms.every((room) => room.isOccupied == false), isTrue);
      expect(
        availableRooms.length,
        equals(service.getOccupancyStats()['availableRooms']),
      );
    });

    test('get all rooms returns seeded inventory', () {
      final service = RoomService();

      final rooms = service.getAllRooms();

      expect(rooms.length, greaterThanOrEqualTo(6));
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

    test('filters doctors by specialization', () {
      final service = DoctorService();

      final cardiologists = service.getDoctorsBySpecialization('Cardiology');

      expect(cardiologists.map((d) => d.id), contains('D002'));
    });

    test('search doctors by name', () {
      final service = DoctorService();

      final results = service.searchDoctorsByName('Sovann');

      expect(results.map((d) => d.id), contains('D001'));
    });

    test('updates existing doctor details', () {
      final service = DoctorService();

      final created = service.createDoctor(
        name: 'Dr. Temp',
        specialization: 'Radiology',
        phoneNumber: '+855-70-000-111',
        email: 'temp.doc@clinic.kh',
        address: 'Phnom Penh',
        age: 39,
        gender: 'Male',
        password: 'temp123',
      );

      expect(created, isNotNull);

      final updatedDoctor = DoctorModel(
        id: created!.id,
        name: 'Dr. Temp Updated',
        specialization: 'Radiology',
        phoneNumber: '+855-70-000-222',
        email: 'temp.doc@clinic.kh',
        address: 'Phnom Penh',
        age: 40,
        gender: 'Male',
        password: 'temp123',
      );

      final updated = service.updateDoctor(updatedDoctor);
      expect(updated, isTrue);

      service.deleteDoctor(created.id);
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

    test('finds manager by email', () {
      final service = ManagerService();

      final manager = service.findManagerByEmail('vannak.sok@clinic.kh');

      expect(manager, isNotNull);
      expect(manager!.id, equals('M001'));
    });

    test('get all managers returns seed data', () {
      final service = ManagerService();

      final managers = service.getAllManagers();

      expect(managers.map((m) => m.id), containsAll(<String>['M001', 'M002']));
    });

    test('updates existing manager', () {
      final service = ManagerService();

      final created = service.createManager(
        name: 'Temp Manager',
        email: 'temp.manager@clinic.kh',
        password: 'pass123',
        age: 29,
        gender: 'Female',
        phoneNumber: '+855-12-345-000',
        address: 'Phnom Penh',
      );

      expect(created, isNotNull);

      final updated = ManagerModel(
        id: created!.id,
        name: 'Temp Manager Updated',
        email: 'temp.manager@clinic.kh',
        password: 'pass123',
        age: 30,
        gender: 'Female',
        phoneNumber: '+855-12-345-000',
        address: 'Phnom Penh',
      );

      final result = service.updateManager(updated);
      expect(result, isTrue);

      service.deleteManager(created.id);
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

    test('filters patients by gender', () {
      final service = PatientService();

      final females = service.getPatientsByGender('Female');

      expect(females, isNotEmpty);
      expect(females.every((p) => p.gender == 'Female'), isTrue);
    });

    test('fetch patient by id', () {
      final service = PatientService();

      final patient = service.getPatientById('P001');

      expect(patient, isNotNull);
      expect(patient!.name, equals('Sok Chan'));
    });

    test('updates existing patient', () {
      final service = PatientService();

      final created = service.createPatient(
        name: 'Temp Patient',
        age: 28,
        gender: 'Male',
        phoneNumber: '+855-70-555-000',
        email: 'temp.patient@clinic.kh',
        address: 'Kampot',
      );

      expect(created, isNotNull);

      final updatedPatient = PatientModel(
        id: created!.id,
        name: 'Temp Patient Updated',
        age: 29,
        gender: 'Male',
        phoneNumber: '+855-70-555-000',
        email: 'temp.patient@clinic.kh',
        address: 'Kampot',
      );

      final updated = service.updatePatient(updatedPatient);
      expect(updated, isTrue);

      service.deletePatient(created.id);
    });
  });
}
