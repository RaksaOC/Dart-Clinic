import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/domain/services/appointment_service.dart';
import 'package:dart_clinic/domain/services/session_service.dart';

void registerAppointmentServiceTests() {
  setUp(() {
    SessionService().logout();
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
}

// Allow running this file independently
void main() {
  setUp(() {
    SessionService().logout();
  });
  registerAppointmentServiceTests();
}
