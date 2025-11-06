import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/doctor.dart';
import 'package:dart_clinic/domain/services/doctor_service.dart';

void registerDoctorServiceTests() {
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

      // D002 (Chenda Phan - Cardiology) -> f8268dc8-34bf-4d12-b6ed-276ac69c1786
      expect(cardiologists.map((d) => d.id), contains('f8268dc8-34bf-4d12-b6ed-276ac69c1786'));
    });

    test('search doctors by name', () {
      final service = DoctorService();

      final results = service.searchDoctorsByName('Sovann');

      // D001 (Dara Sovann) -> a054226d-cad4-427e-b571-a8cc60cf5397
      expect(results.map((d) => d.id), contains('a054226d-cad4-427e-b571-a8cc60cf5397'));
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
        password: created.password, // Keep existing hashed password
      );

      final updated = service.updateDoctor(updatedDoctor);
      expect(updated, isTrue);

      service.deleteDoctor(created.id);
    });
  });
}

// Allow running this file independently
void main() {
  registerDoctorServiceTests();
}
