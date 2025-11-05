/// Doctor Service
///
/// Handles business logic for doctor operations including:
/// - Managing doctor records
/// - Searching doctors
/// - Doctor authentication
///
/// Coordinates between the UI layer and doctor repository.
library;

import '../domain/doctor.dart';
import '../data/doctor_repo.dart';

class DoctorService {
  final DoctorRepository _doctorRepository;

  DoctorService(this._doctorRepository);

  /// Get all doctors
  List<Doctor> getAllDoctors() {
    return _doctorRepository.getAll();
  }

  /// Get doctor by ID
  Doctor? getDoctorById(String doctorId) {
    return _doctorRepository.getById(doctorId);
  }

  /// Get doctors by specialization
  List<Doctor> getDoctorsBySpecialization(String specialization) {
    final doctors = _doctorRepository.getAll();
    return doctors
        .where((doctor) => doctor.specialization == specialization)
        .toList();
  }

  /// Search doctors by name
  List<Doctor> searchDoctorsByName(String name) {
    final doctors = _doctorRepository.getAll();
    final lowerName = name.toLowerCase();
    return doctors
        .where((doctor) => doctor.name.toLowerCase().contains(lowerName))
        .toList();
  }

  /// Create a new doctor
  Doctor? createDoctor({
    required String doctorId,
    required String name,
    required String specialization,
    required String phoneNumber,
    required String email,
    required String address,
    required int age,
    required String gender,
    required String password,
  }) {
    final doctor = Doctor(
      id: doctorId,
      name: name,
      specialization: specialization,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      age: age,
      gender: gender,
      password: password,
    );
    return _doctorRepository.create(doctor);
  }

  /// Update a doctor's information
  bool updateDoctor(Doctor doctor) {
    return _doctorRepository.update(doctor);
  }

  /// Delete a doctor
  bool deleteDoctor(String doctorId) {
    return _doctorRepository.delete(doctorId);
  }
}
