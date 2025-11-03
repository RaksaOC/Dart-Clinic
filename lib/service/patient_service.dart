/// Patient Service
///
/// Handles business logic for patient operations including:
/// - Managing patient records
/// - Searching patients
/// - Patient admission status
///
/// Coordinates between the UI layer and patient repository.
library;

import '../domain/patient.dart';
import '../data/patient_repo.dart';

class PatientService {
  final PatientRepository _patientRepository;

  PatientService(this._patientRepository);

  /// Get all patients
  Future<List<Patient>> getAllPatients() async {
    return await _patientRepository.getAll();
  }

  /// Get patient by ID
  Future<Patient?> getPatientById(String patientId) async {
    return await _patientRepository.getById(patientId);
  }

  /// Search patients by name
  Future<List<Patient>> searchPatientsByName(String name) async {
    return await _patientRepository.getByName(name);
  }

  /// Get admitted patients
  Future<List<Patient>> getAdmittedPatients() async {
    return await _patientRepository.getAdmittedPatients();
  }

  /// Get patients by gender
  Future<List<Patient>> getPatientsByGender(String gender) async {
    return await _patientRepository.getByGender(gender);
  }

  /// Create a new patient
  Future<Patient?> createPatient({
    required String patientId,
    required String name,
    required int age,
    required String gender,
    required String phoneNumber,
    required String email,
    required String address,
    String? bloodType,
    String? allergies,
    bool isAdmitted = false,
  }) async {
    final patient = Patient(
      id: patientId,
      name: name,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      bloodType: bloodType,
      allergies: allergies,
      isAdmitted: isAdmitted,
    );
    return await _patientRepository.create(patient);
  }

  /// Update patient information
  Future<bool> updatePatient(Patient patient) async {
    return await _patientRepository.update(patient);
  }

  /// Delete a patient
  Future<bool> deletePatient(String patientId) async {
    return await _patientRepository.delete(patientId);
  }

  /// Admit a patient
  Future<bool> admitPatient(String patientId) async {
    final patient = await _patientRepository.getById(patientId);
    if (patient == null || patient.isAdmitted) {
      return false;
    }

    final admittedPatient = Patient(
      id: patient.id,
      name: patient.name,
      age: patient.age,
      gender: patient.gender,
      phoneNumber: patient.phoneNumber,
      email: patient.email,
      address: patient.address,
      bloodType: patient.bloodType,
      allergies: patient.allergies,
      isAdmitted: true,
    );

    return await _patientRepository.update(admittedPatient);
  }

  /// Discharge a patient
  Future<bool> dischargePatient(String patientId) async {
    final patient = await _patientRepository.getById(patientId);
    if (patient == null || !patient.isAdmitted) {
      return false;
    }

    final dischargedPatient = Patient(
      id: patient.id,
      name: patient.name,
      age: patient.age,
      gender: patient.gender,
      phoneNumber: patient.phoneNumber,
      email: patient.email,
      address: patient.address,
      bloodType: patient.bloodType,
      allergies: patient.allergies,
      isAdmitted: false,
    );

    return await _patientRepository.update(dischargedPatient);
  }
}
