import 'package:test/test.dart';
import 'package:dart_clinic/domain/services/prescription_service.dart';
import 'package:dart_clinic/domain/services/session_service.dart';
import 'package:dart_clinic/domain/services/doctor_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void registerPrescriptionServiceTests() {
  setUp(() {
    SessionService().logout();
  });

  group('PrescriptionService', () {
    test('issues a prescription and makes it discoverable', () {
      final session = SessionService();
      final d = session.loginDoctor('qw', 'qw');
      if (d == null) {
        DoctorService().createDoctor(
          name: 'Temp Auth Doctor',
          specialization: 'General',
          phoneNumber: '+855-00-000-000',
          email: 'test.doc@clinic.kh',
          address: 'PP',
          age: 30,
          gender: 'Other',
          password: 'authpass',
        );
        session.loginDoctor('test.doc@clinic.kh', 'authpass');
      }
      final prescriptionService = PrescriptionService();

      final issued = prescriptionService.issuePrescription(
        patientId: '67514370-83ed-4960-862a-11992d4dda4d', // P003
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
        '67514370-83ed-4960-862a-11992d4dda4d', // P003
      );
      expect(patientPrescriptions.map((rx) => rx.id), contains(issued.id));
    });

    test('loads prescriptions for logged-in doctor', () {
      final session = SessionService();
      if (session.currentDoctor == null) {
        final d = session.loginDoctor('qw', 'qw');
        if (d == null) {
          DoctorService().createDoctor(
            name: 'Temp Auth Doctor',
            specialization: 'General',
            phoneNumber: '+855-00-000-000',
            email: 'test.doc@clinic.kh',
            address: 'PP',
            age: 30,
            gender: 'Other',
            password: 'authpass',
          );
          session.loginDoctor('test.doc@clinic.kh', 'authpass');
        }
      }
      final prescriptionService = PrescriptionService();

      var myPrescriptions = prescriptionService.getMyPrescriptions();
      if (myPrescriptions.isEmpty) {
        prescriptionService.issuePrescription(
          patientId: '67514370-83ed-4960-862a-11992d4dda4d',
          medicationName: 'TestMed',
          dosage: '1u',
          frequency: '1x/day',
          durationDays: 3,
          instructions: 'With water',
          notes: 'auto',
        );
        myPrescriptions = prescriptionService.getMyPrescriptions();
      }
      expect(myPrescriptions, isNotEmpty);
      final currentDoctorId = SessionService().currentDoctor!.id;
      expect(
        myPrescriptions.every((rx) => rx.doctorId == currentDoctorId),
        isTrue,
      );
    });

    test('retrieves prescriptions for patient', () {
      final prescriptionService = PrescriptionService();

      final prescriptions = prescriptionService.getPatientPrescriptions(
        'c378f0b6-45c9-4b6a-9e96-35262de8895d',
      ); // P001

      expect(
        prescriptions.map((rx) => rx.id),
        contains('7edd3752-a340-44cd-8b93-c391d0e330d5'),
      ); // RX002
    });

    test('gets prescription by id for logged-in doctor', () {
      final session = SessionService();
      if (session.currentDoctor == null) {
        final d = session.loginDoctor('qw', 'qw');
        if (d == null) {
          DoctorService().createDoctor(
            name: 'Temp Auth Doctor',
            specialization: 'General',
            phoneNumber: '+855-00-000-000',
            email: 'test.doc@clinic.kh',
            address: 'PP',
            age: 30,
            gender: 'Other',
            password: 'authpass',
          );
          session.loginDoctor('test.doc@clinic.kh', 'authpass');
        }
      }
      final prescriptionService = PrescriptionService();

      // Issue one under current doctor and fetch by its id
      final issued = prescriptionService.issuePrescription(
        patientId: '67514370-83ed-4960-862a-11992d4dda4d',
        medicationName: 'TestMed2',
        dosage: '1u',
        frequency: '1x/day',
        durationDays: 2,
        instructions: 'With water',
        notes: 'auto2',
      );
      final rx = prescriptionService.getById(issued!.id);

      expect(rx, isNotNull);
      expect(rx!.patientId, equals('67514370-83ed-4960-862a-11992d4dda4d'));
    });
  });
}

// Allow running this file independently
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
  registerPrescriptionServiceTests();
}
