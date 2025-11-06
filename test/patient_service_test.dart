import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/patient.dart';
import 'package:dart_clinic/domain/services/patient_service.dart';

void registerPatientServiceTests() {
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

      final patient = service.getPatientById('c378f0b6-45c9-4b6a-9e96-35262de8895d'); // P001

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

// Allow running this file independently
void main() {
  registerPatientServiceTests();
}
