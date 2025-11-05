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
  List<Patient> getAllPatients() {
    return _patientRepository.getAll();
  }

  /// Get patient by ID
  Patient? getPatientById(String patientId) {
    return _patientRepository.getById(patientId);
  }

  /// Search patients by name
  List<Patient> searchPatientsByName(String name) {
    final patients = _patientRepository.getAll();
    final lowerName = name.toLowerCase();
    return patients
        .where((patient) => patient.name.toLowerCase().contains(lowerName))
        .toList();
  }

  /// Get admitted patients
  /// Note: This requires checking with AdmissionService for admission status
  /// For now, returns empty list - admission status is managed separately
  List<Patient> getAdmittedPatients() {
    // TODO: Implement by checking AdmissionService for active admissions
    return [];
  }

  /// Get patients by gender
  List<Patient> getPatientsByGender(String gender) {
    final patients = _patientRepository.getAll();
    return patients.where((patient) => patient.gender == gender).toList();
  }

  /// Create a new patient
  Patient? createPatient({
    required String patientId,
    required String name,
    required int age,
    required String gender,
    required String phoneNumber,
    required String email,
    required String address,
  }) {
    final patient = Patient(
      id: patientId,
      name: name,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
    );
    return _patientRepository.create(patient);
  }

  /// Update patient information
  bool updatePatient(Patient patient) {
    return _patientRepository.update(patient);
  }

  /// Delete a patient
  bool deletePatient(String patientId) {
    return _patientRepository.delete(patientId);
  }

  /// Admit a patient
  /// Note: Admission is now handled by AdmissionService
  /// This method is deprecated - use AdmissionService.admitPatient instead
  @Deprecated('Use AdmissionService.admitPatient instead')
  bool admitPatient(String patientId) {
    // Admission is now managed by AdmissionService
    return false;
  }

  /// Discharge a patient
  /// Note: Discharge is now handled by AdmissionService
  /// This method is deprecated - use AdmissionService.dischargePatient instead
  @Deprecated('Use AdmissionService.dischargePatient instead')
  bool dischargePatient(String patientId) {
    // Discharge is now managed by AdmissionService
    return false;
  }
}
