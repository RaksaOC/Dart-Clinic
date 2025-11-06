/// Appointment Service
///
/// Handles business logic for appointment operations including:
/// - Creating and scheduling appointments
/// - Cancelling appointments
/// - Updating appointment status
/// - Querying appointments by various criteria
///
/// Coordinates between the UI layer and appointment repository.
library;

import 'package:dart_clinic/data/patient_repo.dart';
import 'package:dart_clinic/domain/models/status.dart';
import 'package:dart_clinic/domain/services/session_service.dart';

import '../models/appointment.dart';
import '../../data/appointment_repo.dart';
import 'package:uuid/uuid.dart';

class AppointmentService {
  final AppointmentRepository _appointmentRepository;
  final PatientRepository _patientRepository;
  AppointmentService({
    AppointmentRepository? appointmentRepository,
    PatientRepository? patientRepository,
  }) : _appointmentRepository =
           appointmentRepository ?? AppointmentRepository(),
       _patientRepository = patientRepository ?? PatientRepository();

  /// Create a new appointment
  AppointmentModel? createAppointment({
    required String patientId,
    required DateTime appointmentDateTime,
    String? notes,
  }) {
    final currentDoctor = SessionService().currentDoctor;
    if (currentDoctor == null) return null;
    if (_patientRepository.getById(patientId) == null) return null;
    final String id = const Uuid().v4();
    if (_appointmentRepository.getById(id) != null) {
      return null;
    }
    
    final existsSameSlot = _appointmentRepository.getAll().any(
      (a) =>
          a.doctorId == currentDoctor.id &&
          a.appointmentDateTime == appointmentDateTime &&
          a.status != AppointmentStatus.cancelled,
    );
    if (existsSameSlot) return null;
    final appointment = AppointmentModel(
      id: id,
      doctorId: currentDoctor.id,
      patientId: patientId,
      appointmentDateTime: appointmentDateTime,
      status: AppointmentStatus.scheduled,
      notes: notes,
      createdAt: DateTime.now(),
    );
    return _appointmentRepository.create(appointment);
  }

  /// Cancel an existing appointment
  bool cancelAppointment(String appointmentId) {
    final appointment = _appointmentRepository.getById(appointmentId);
    if (appointment == null) {
      return false;
    }
    final currentDoctor = SessionService().currentDoctor;
    if (currentDoctor != null && appointment.doctorId != currentDoctor.id) {
      return false;
    }
    // Cannot cancel completed or already cancelled
    if (appointment.status == AppointmentStatus.completed ||
        appointment.status == AppointmentStatus.cancelled) {
      return false;
    }
    // Enforce 24h window
    final now = DateTime.now();
    if (!appointment.appointmentDateTime.isAfter(
      now.add(const Duration(hours: 24)),
    )) {
      return false;
    }

    final cancelledAppointment = AppointmentModel(
      id: appointment.id,
      doctorId: appointment.doctorId,
      patientId: appointment.patientId,
      appointmentDateTime: appointment.appointmentDateTime,
      status: AppointmentStatus.cancelled,
      notes: appointment.notes,
      diagnosis: appointment.diagnosis,
      createdAt: appointment.createdAt,
    );

    return _appointmentRepository.update(cancelledAppointment);
  }

  /// Get all appointments for a doctor
  List<AppointmentModel> getMyAppointments() {
    final currentDoctor = SessionService().currentDoctor;
    final appointments = _appointmentRepository.getAll();
    if (currentDoctor == null) return [];
    return appointments.where((a) => a.doctorId == currentDoctor.id).toList();
  }

  /// Get all appointments for a patient
  List<AppointmentModel> getPatientAppointments(String patientId) {
    final appointments = _appointmentRepository.getAll();
    return appointments.where((a) => a.patientId == patientId).toList();
  }

  /// Complete an appointment and add diagnosis
  bool completeAppointment(
    String appointmentId,
    String diagnosis,
    String? notes,
  ) {
    final appointment = _appointmentRepository.getById(appointmentId);
    if (appointment == null) {
      return false;
    }
    final currentDoctor = SessionService().currentDoctor;
    if (currentDoctor != null && appointment.doctorId != currentDoctor.id) {
      return false;
    }
    // Cannot complete if already cancelled or completed
    if (appointment.status == AppointmentStatus.cancelled ||
        appointment.status == AppointmentStatus.completed) {
      return false;
    }

    final completedAppointment = AppointmentModel(
      id: appointment.id,
      doctorId: appointment.doctorId,
      patientId: appointment.patientId,
      appointmentDateTime: appointment.appointmentDateTime,
      status: AppointmentStatus.completed,
      notes: notes ?? appointment.notes,
      diagnosis: diagnosis,
      createdAt: appointment.createdAt,
    );

    return _appointmentRepository.update(completedAppointment);
  }

  /// Get upcoming appointments within a date range
  List<AppointmentModel> getUpcomingAppointments(
    DateTime startDate,
    DateTime endDate,
  ) {
    final appointments = _appointmentRepository.getAll();
    return appointments.where((a) {
      return a.appointmentDateTime.isAfter(
            startDate.subtract(const Duration(seconds: 1)),
          ) &&
          a.appointmentDateTime.isBefore(
            endDate.add(const Duration(seconds: 1)),
          );
    }).toList();
  }

  List<AppointmentModel> getMyUpcomingAppointments() {
    final my = getMyAppointments();
    final startDate = DateTime.now();
    final endDate = startDate.add(const Duration(days: 30));
    return my
        .where(
          (a) =>
              a.appointmentDateTime.isAfter(startDate) &&
              a.appointmentDateTime.isBefore(endDate),
        )
        .toList();
  }

  List<AppointmentModel> getMyPastAppointments() {
    final my = getMyAppointments();
    final now = DateTime.now();
    return my.where((a) => a.appointmentDateTime.isBefore(now)).toList();
  }

  /// Get appointments by status
  List<AppointmentModel> getByStatus(AppointmentStatus status) {
    final appointments = _appointmentRepository.getAll();
    return appointments.where((a) => a.status == status).toList();
  }

  List<AppointmentModel> getMyAppointmentsByStatus(AppointmentStatus status) {
    final my = getMyAppointments();
    return my.where((a) => a.status == status).toList();
  }

  /// Get appointment by id
  AppointmentModel? getById(String id) {
    final appointment = _appointmentRepository.getById(id);
    if (appointment == null) return null;
    final currentDoctor = SessionService().currentDoctor;
    if (currentDoctor != null && appointment.doctorId != currentDoctor.id) {
      return null;
    }
    return appointment;
  }
}
