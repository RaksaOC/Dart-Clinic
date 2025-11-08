/// Patients Controller (Manager)
library;

import '../../../domain/services/patient_service.dart';
import '../../../domain/services/admission_service.dart';
import '../../../domain/models/patient.dart';

class PatientsController {
  final PatientService _patientService;
  final AdmissionService _admissionService;

  PatientsController({
    PatientService? patientService,
    AdmissionService? admissionService,
  }) : _patientService = patientService ?? PatientService(),
       _admissionService = admissionService ?? AdmissionService();

  PatientModel? createPatient({
    required String name,
    required int age,
    required String gender,
    required String phoneNumber,
    required String email,
    required String address,
  }) {
    return _patientService.createPatient(
      name: name,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
    );
  }

  List<PatientModel> getAllPatients() => _patientService.getAllPatients();
  PatientModel? getPatientById(String id) => _patientService.getPatientById(id);
  List<PatientModel> getPatientsByGender(String g) =>
      _patientService.getPatientsByGender(g);

  List<PatientModel> getAdmittedPatients() =>
      _admissionService.getAdmittedPatients();

  bool updatePatient(PatientModel p) => _patientService.updatePatient(p);

  bool deletePatient(String id) => _patientService.deletePatient(id);
}
