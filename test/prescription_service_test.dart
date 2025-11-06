import 'package:test/test.dart';
import 'package:dart_clinic/services/prescription_service.dart';
import 'package:dart_clinic/services/session_service.dart';

void registerPrescriptionServiceTests() {
  setUp(() {
    SessionService().logout();
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
}

// Allow running this file independently
void main() {
  setUp(() {
    SessionService().logout();
  });
  registerPrescriptionServiceTests();
}
