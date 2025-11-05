/// Patients Controller (Doctor)
library;

import '../../../services/patient_service.dart';
import '../../../services/appointment_service.dart';
import '../../../services/prescription_service.dart';
import '../../../domain/models/patient.dart';
import '../../../domain/models/appointment.dart';
import '../../../domain/models/prescription.dart';

class PatientsController {
  final PatientService _patientService;
  final AppointmentService _appointmentService;
  final PrescriptionService _prescriptionService;

  PatientsController({
    PatientService? patientService,
    AppointmentService? appointmentService,
    PrescriptionService? prescriptionService,
  }) : _patientService = patientService ?? PatientService(),
       _appointmentService = appointmentService ?? AppointmentService(),
       _prescriptionService = prescriptionService ?? PrescriptionService();

  PatientModel? getPatientById(String id) => _patientService.getPatientById(id);
  List<PatientModel> getAllPatients() => _patientService.getAllPatients();

  List<AppointmentModel> getPatientAppointments(String patientId) =>
      _appointmentService.getPatientAppointments(patientId);

  List<PrescriptionModel> getPatientPrescriptions(String patientId) =>
      _prescriptionService.getPatientPrescriptions(patientId);
}
