import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/services/admission_service.dart';

void registerAdmissionServiceTests() {
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
}

// Allow running this file independently
void main() {
  registerAdmissionServiceTests();
}
