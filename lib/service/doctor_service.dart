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
  Future<List<Doctor>> getAllDoctors() async {
    return await _doctorRepository.getAll();
  }

  /// Get doctor by ID
  Future<Doctor?> getDoctorById(String doctorId) async {
    return await _doctorRepository.getById(doctorId);
  }

  /// Get doctors by specialization
  Future<List<Doctor>> getDoctorsBySpecialization(String specialization) async {
    return await _doctorRepository.getBySpecialization(specialization);
  }

  /// Search doctors by name
  Future<List<Doctor>> searchDoctorsByName(String name) async {
    return await _doctorRepository.getByName(name);
  }

  /// Create a new doctor
  Future<Doctor?> createDoctor({
    required String doctorId,
    required String name,
    required String specialization,
    required String phoneNumber,
    required String email,
  }) async {
    final doctor = Doctor(
      id: doctorId,
      name: name,
      specialization: specialization,
      phoneNumber: phoneNumber,
      email: email,
    );
    return await _doctorRepository.create(doctor);
  }

  /// Update a doctor's information
  Future<bool> updateDoctor(Doctor doctor) async {
    return await _doctorRepository.update(doctor);
  }

  /// Delete a doctor
  Future<bool> deleteDoctor(String doctorId) async {
    return await _doctorRepository.delete(doctorId);
  }
}
