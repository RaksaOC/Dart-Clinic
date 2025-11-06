import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/doctor.dart';
import 'package:dart_clinic/services/doctor_service.dart';

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
}

// Allow running this file independently
void main() {
  registerDoctorServiceTests();
}
