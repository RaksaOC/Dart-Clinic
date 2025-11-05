/// Doctor Usecase
///
/// Orchestrates doctor operations. Acts as the public API for doctor functionality.
/// UI layer interacts with this class, which delegates to services.
library;

import '../models/appointment.dart';
import '../models/prescription.dart';
import '../models/patient.dart';
import '../models/status.dart';
import '../../service/appointment_service.dart';
import '../../service/prescription_service.dart';
import '../../service/patient_service.dart';
// Repositories are not referenced here; this layer talks to services only.

class Doctor {
  final AppointmentService _appointmentService;
  final PrescriptionService _prescriptionService;
  final PatientService _patientService;
  // Note: No repositories or session here; services handle session
  Doctor({
    AppointmentService? appointmentService,
    PrescriptionService? prescriptionService,
    PatientService? patientService,
  }) : _appointmentService = appointmentService ?? AppointmentService(),
       _prescriptionService = prescriptionService ?? PrescriptionService(),
       _patientService = patientService ?? PatientService();

  // ========== Appointment Management ==========

  /// Create a new appointment
  AppointmentModel? createAppointment({
    required String appointmentId,
    required String patientId,
    required DateTime appointmentDateTime,
    String? notes,
  }) {
    // Validate patient exists
    final patient = _patientService.getPatientById(patientId);
    if (patient == null) {
      return null; // Patient not found
    }

    return _appointmentService.createAppointment(
      appointmentId: appointmentId,
      patientId: patientId,
      appointmentDateTime: appointmentDateTime,
      notes: notes,
    );
  }

  /// Get my appointments
  List<AppointmentModel> getMyAppointments() {
    return _appointmentService.getMyAppointments();
  }

  AppointmentModel? getAppointmentById(String appointmentId) {
    return _appointmentService.getById(appointmentId);
  }

  /// Get patient appointments
  List<AppointmentModel> getPatientAppointments(String patientId) {
    return _appointmentService.getPatientAppointments(patientId);
  }

  /// Cancel an appointment
  bool cancelAppointment(String appointmentId) {
    return _appointmentService.cancelAppointment(appointmentId);
  }

  /// Complete an appointment and add diagnosis
  bool completeAppointment({
    required String appointmentId,
    required String diagnosis,
    String? notes,
  }) {
    return _appointmentService.completeAppointment(
      appointmentId,
      diagnosis,
      notes,
    );
  }

  /// Get upcoming appointments within a date range
  List<AppointmentModel> getUpcomingAppointments(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _appointmentService.getMyUpcomingAppointments(startDate, endDate);
  }

  /// Get appointments by status
  List<AppointmentModel> getAppointmentsByStatus(AppointmentStatus status) {
    return _appointmentService.getMyAppointmentsByStatus(status);
  }

  /// Get all appointments by status (from service)
  List<AppointmentModel> getAllAppointmentsByStatus(AppointmentStatus status) {
    return _appointmentService.getByStatus(status);
  }

  /// Get today's appointments
  List<AppointmentModel> getTodaysAppointments() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return _appointmentService.getMyUpcomingAppointments(startOfDay, endOfDay);
  }

  /// Get past appointments
  List<AppointmentModel> getPastAppointments() {
    final now = DateTime.now();
    return _appointmentService
        .getMyAppointments()
        .where((a) => a.appointmentDateTime.isBefore(now))
        .toList();
  }

  // ========== Prescription Management ==========

  /// Issue a prescription
  PrescriptionModel? issuePrescription({
    required String prescriptionId,
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    required String instructions,
    String? notes,
  }) {
    // Validate patient exists
    final patient = _patientService.getPatientById(patientId);
    if (patient == null) {
      return null; // Patient not found
    }

    return _prescriptionService.issuePrescription(
      prescriptionId: prescriptionId,
      patientId: patientId,
      medicationName: medicationName,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
      instructions: instructions,
      notes: notes,
    );
  }

  /// Get prescription by ID
  PrescriptionModel? getPrescriptionById(String prescriptionId) {
    return _prescriptionService.getById(prescriptionId);
  }

  /// Get all prescriptions (all doctors)
  List<PrescriptionModel> getAllPrescriptions() {
    // No global list needed; provide my prescriptions instead
    return getMyPrescriptions();
  }

  /// Get patient prescriptions
  List<PrescriptionModel> getPatientPrescriptions(String patientId) {
    return _prescriptionService.getPatientPrescriptions(patientId);
  }

  /// Get my prescriptions (prescriptions I issued)
  List<PrescriptionModel> getMyPrescriptions() {
    return _prescriptionService.getMyPrescriptions();
  }

  // ========== Patient Queries ==========

  /// Get patient by ID (for validation/display)
  PatientModel? getPatientById(String patientId) {
    return _patientService.getPatientById(patientId);
  }

  /// Get all patients
  List<PatientModel> getAllPatients() {
    return _patientService.getAllPatients();
  }

  /// Search patients by name
  List<PatientModel> searchPatientsByName(String name) {
    return _patientService.searchPatientsByName(name);
  }

  /// Get patients by gender
  List<PatientModel> getPatientsByGender(String gender) {
    return _patientService.getPatientsByGender(gender);
  }
}
