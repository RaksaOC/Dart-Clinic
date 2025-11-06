import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/domain/services/admission_service.dart';

void registerAdmissionServiceTests() {
  group('AdmissionService', () {
    test('admits and discharges patient correctly', () {
      final admissionService = AdmissionService();

      final admission = admissionService.admitPatient(
        patientId: 'ccd17498-7315-4e7d-a185-90fb7dcca2d0', // P002
        roomId: 'b4838a50-2024-4bcb-9390-e32c56a14731', // R004
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
        patientId: '67514370-83ed-4960-862a-11992d4dda4d', // P003
        roomId: '289da33f-13c8-4bfb-b02f-4f098c7b32f5', // R005
        notes: 'Initial stay',
      );

      expect(first, isNotNull);

      final second = admissionService.admitPatient(
        patientId: '67514370-83ed-4960-862a-11992d4dda4d', // P003
        roomId: 'd0d7cc98-3a65-4838-b169-2afdd937c2bd', // R006
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

      final admission = admissionService.getById('f8468d3b-eddf-4b2a-b5df-6d2a2bfbe548'); // A001

      expect(admission, isNotNull);
      expect(admission!.patientId, equals('c378f0b6-45c9-4b6a-9e96-35262de8895d')); // P001
    });
  });
}

// Allow running this file independently
void main() {
  registerAdmissionServiceTests();
}
