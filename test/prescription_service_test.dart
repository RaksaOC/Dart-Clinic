import 'package:test/test.dart';
import 'package:dart_clinic/domain/services/prescription_service.dart';
import 'package:dart_clinic/domain/services/session_service.dart';

void registerPrescriptionServiceTests() {
  setUp(() {
    SessionService().logout();
  });

  group('PrescriptionService', () {
    test('issues a prescription and makes it discoverable', () {
      SessionService().loginDoctor('qw', 'qw');
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
      SessionService().loginDoctor('qw', 'qw');
      final prescriptionService = PrescriptionService();

      final myPrescriptions = prescriptionService.getMyPrescriptions();

      expect(myPrescriptions, isNotEmpty);
      // D001 -> a054226d-cad4-427e-b571-a8cc60cf5397
      expect(myPrescriptions.every((rx) => rx.doctorId == 'a054226d-cad4-427e-b571-a8cc60cf5397'), isTrue);
    });

    test('retrieves prescriptions for patient', () {
      final prescriptionService = PrescriptionService();

      final prescriptions = prescriptionService.getPatientPrescriptions('c378f0b6-45c9-4b6a-9e96-35262de8895d'); // P001

      expect(prescriptions.map((rx) => rx.id), contains('7edd3752-a340-44cd-8b93-c391d0e330d5')); // RX002
    });

    test('gets prescription by id for logged-in doctor', () {
      SessionService().loginDoctor('qw', 'qw');
      final prescriptionService = PrescriptionService();

      final rx = prescriptionService.getById('7edd3752-a340-44cd-8b93-c391d0e330d5'); // RX002

      expect(rx, isNotNull);
      expect(rx!.patientId, equals('c378f0b6-45c9-4b6a-9e96-35262de8895d')); // P001
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
