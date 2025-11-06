import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/domain/services/appointment_service.dart';
import 'package:dart_clinic/domain/services/session_service.dart';
import 'package:dart_clinic/domain/services/doctor_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void registerAppointmentServiceTests() {
  setUp(() {
    SessionService().logout();
  });

  group('AppointmentService', () {
    test('requires login to create appointment', () {
      final appointmentService = AppointmentService();

      final created = appointmentService.createAppointment(
        patientId: 'ccd17498-7315-4e7d-a185-90fb7dcca2d0', // P002
        appointmentDateTime: DateTime.now().add(const Duration(days: 1)),
        notes: 'Should not be created',
      );

      expect(created, isNull);
    });

    test('creates and persists a scheduled appointment', () {
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
      final appointmentService = AppointmentService();

      final futureSlot = DateTime.now().add(const Duration(days: 2));
      final created = appointmentService.createAppointment(
        patientId: 'ccd17498-7315-4e7d-a185-90fb7dcca2d0',
        appointmentDateTime: futureSlot,
        notes: 'Routine check-up',
      );

      expect(created, isNotNull);

      final stored = appointmentService.getById(created!.id);
      expect(stored, isNotNull);
      expect(stored!.status, AppointmentStatus.scheduled);
      expect(stored.patientId, equals('ccd17498-7315-4e7d-a185-90fb7dcca2d0'));
    });

    test('rejects double-booking the same timeslot for the doctor', () {
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
      final appointmentService = AppointmentService();

      final conflictingSlot = DateTime.now().add(const Duration(days: 10));
      final first = appointmentService.createAppointment(
        patientId: '67514370-83ed-4960-862a-11992d4dda4d',
        appointmentDateTime: conflictingSlot,
        notes: 'First booking',
      );
      expect(first, isNotNull);
      final second = appointmentService.createAppointment(
        patientId: '67514370-83ed-4960-862a-11992d4dda4d',
        appointmentDateTime: conflictingSlot,
        notes: 'Should fail',
      );
      expect(second, isNull);
    });

    test('retrieves appointments for patient', () {
      SessionService().loginDoctor('qw', 'qw');
      final appointmentService = AppointmentService();

      final patientAppointments = appointmentService.getPatientAppointments(
        'c378f0b6-45c9-4b6a-9e96-35262de8895d',
      );

      expect(
        patientAppointments.map((a) => a.id),
        contains('24569893-0db8-45a0-a740-53a9a370b557'),
      ); // AP001
    });

    test('returns only logged-in doctor appointments', () {
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
      final appointmentService = AppointmentService();

      var myAppointments = appointmentService.getMyAppointments();
      if (myAppointments.isEmpty) {
        final futureSlot = DateTime.now().add(const Duration(days: 3));
        appointmentService.createAppointment(
          patientId: 'ccd17498-7315-4e7d-a185-90fb7dcca2d0',
          appointmentDateTime: futureSlot,
          notes: 'Auto-generated',
        );
        myAppointments = appointmentService.getMyAppointments();
      }
      expect(myAppointments, isNotEmpty);
      final currentDoctorId = SessionService().currentDoctor!.id;
      expect(
        myAppointments.every((a) => a.doctorId == currentDoctorId),
        isTrue,
      );
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
  setUp(() {
    SessionService().logout();
  });
  registerAppointmentServiceTests();
}
