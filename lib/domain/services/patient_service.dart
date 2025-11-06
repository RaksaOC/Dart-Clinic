/// Patient Service
///
/// Handles business logic for patient operations including:
/// - Managing patient records
/// - Searching patients
/// - Patient admission status
///
/// Coordinates between the UI layer and patient repository.
library;

import 'package:dart_clinic/domain/services/admission_service.dart';

import '../models/patient.dart';
import '../../data/patient_repo.dart';
import 'package:uuid/uuid.dart';

class PatientService {
  final PatientRepository _patientRepository;
  final AdmissionService _admissionService;
  PatientService({
    PatientRepository? patientRepository,
    AdmissionService? admissionService,
  }) : _patientRepository = patientRepository ?? PatientRepository(),
       _admissionService = admissionService ?? AdmissionService();

  /// Get all patients
  List<PatientModel> getAllPatients() {
    return _patientRepository.getAll();
  }

  /// Get patient by ID
  PatientModel? getPatientById(String patientId) {
    return _patientRepository.getById(patientId);
  }

  /// Get patients by gender
  List<PatientModel> getPatientsByGender(String gender) {
    final patients = _patientRepository.getAll();
    return patients.where((patient) => patient.gender == gender).toList();
  }

  /// Create a new patient
  PatientModel? createPatient({
    required String name,
    required int age,
    required String gender,
    required String phoneNumber,
    required String email,
    required String address,
  }) {
    // Generate id
    final String id = const Uuid().v4();
    // Uniqueness check
    if (_patientRepository.getById(id) != null) {
      return null;
    }
    final patient = PatientModel(
      id: id,
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
  bool updatePatient(PatientModel patient) {
    return _patientRepository.update(patient);
  }

  /// Delete a patient
  bool deletePatient(String patientId) {
    if (_admissionService.getActiveByPatientId(patientId) != null) return false;
    return _patientRepository.delete(patientId);
  }
}
