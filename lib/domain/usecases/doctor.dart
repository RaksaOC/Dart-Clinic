/// Doctor Usecase
///
/// Orchestrates doctor operations. Acts as the public API for doctor functionality.
/// UI layer interacts with this class, which delegates to services.
library;

import 'package:dart_clinic/service/session_service.dart';

import '../models/doctor.dart';
import '../models/appointment.dart';
import '../models/prescription.dart';
import '../models/patient.dart';
import '../models/status.dart';
import '../../service/appointment_service.dart';
import '../../service/prescription_service.dart';
import '../../service/patient_service.dart';
// Repositories are not referenced here; this layer talks to services only.

class Doctor {
  final DoctorModel _currentDoctor;
  final AppointmentService _appointmentService;
  final PrescriptionService _prescriptionService;
  final PatientService _patientService;
  // Note: No repositories or extra services needed here
  Doctor({
    AppointmentService? appointmentService,
    PrescriptionService? prescriptionService,
    PatientService? patientService,
  }) : _currentDoctor = SessionService().currentDoctor!,
       _appointmentService = appointmentService ?? AppointmentService(),
       _prescriptionService = prescriptionService ?? PrescriptionService(),
       _patientService = patientService ?? PatientService();

  /// Get current doctor model
  DoctorModel get currentDoctor => _currentDoctor;

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

    // Delegate to appointment service
    final doctorId = _currentDoctor.id;
    return _appointmentService.createAppointment(
      appointmentId: appointmentId,
      doctorId: doctorId,
      patientId: patientId,
      appointmentDateTime: appointmentDateTime,
      notes: notes,
    );
  }

  /// Get appointment by ID
  AppointmentModel? getAppointmentById(String appointmentId) {
    final appointment = _appointmentService.getById(appointmentId);
    // Verify appointment belongs to this doctor
    if (appointment != null && appointment.doctorId == _currentDoctor.id) {
      return appointment;
    }
    return null;
  }

  /// Get all appointments (all doctors)
  List<AppointmentModel> getAllAppointments() {
    // Expose all via service if needed; otherwise keep using doctor-scoped APIs
    return _appointmentService.getUpcomingAppointments(
      DateTime.fromMillisecondsSinceEpoch(0),
      DateTime.now().add(const Duration(days: 3650)),
    );
  }

  /// Get my appointments
  List<AppointmentModel> getMyAppointments() {
    final doctorId = _currentDoctor.id;
    return _appointmentService.getDoctorAppointments(doctorId);
  }

  /// Get patient appointments
  List<AppointmentModel> getPatientAppointments(String patientId) {
    return _appointmentService.getPatientAppointments(patientId);
  }

  /// Cancel an appointment
  bool cancelAppointment(String appointmentId) {
    // Verify appointment belongs to this doctor
    final appointments = _appointmentService.getDoctorAppointments(
      _currentDoctor.id,
    );
    appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception('Appointment not found'),
    );

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
    final upcoming = _appointmentService.getUpcomingAppointments(
      startDate,
      endDate,
    );
    // Filter to only this doctor's appointments
    final doctorId = _currentDoctor.id;
    return upcoming.where((a) => a.doctorId == doctorId).toList();
  }

  /// Get appointments by status
  List<AppointmentModel> getAppointmentsByStatus(AppointmentStatus status) {
    final myAppointments = getMyAppointments();
    return myAppointments.where((a) => a.status == status).toList();
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
    return getUpcomingAppointments(startOfDay, endOfDay);
  }

  /// Get past appointments
  List<AppointmentModel> getPastAppointments() {
    final myAppointments = getMyAppointments();
    final now = DateTime.now();
    return myAppointments
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

    // Delegate to prescription service
    final doctorId = _currentDoctor.id;
    return _prescriptionService.issuePrescription(
      prescriptionId: prescriptionId,
      doctorId: doctorId,
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
    final prescription = _prescriptionService.getById(prescriptionId);
    // Verify prescription belongs to this doctor
    if (prescription != null && prescription.doctorId == _currentDoctor.id) {
      return prescription;
    }
    return null;
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
    final doctorId = _currentDoctor.id;
    return _prescriptionService.getDoctorPrescriptions(doctorId);
  }

  // Authentication is out of scope here; handled by separate flows

  /// Get prescriptions for a patient that I issued
  List<PrescriptionModel> getMyPrescriptionsForPatient(String patientId) {
    final myPrescriptions = getMyPrescriptions();
    return myPrescriptions.where((p) => p.patientId == patientId).toList();
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
