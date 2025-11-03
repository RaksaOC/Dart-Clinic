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

import '../domain/appointment.dart';
import '../data/appointment_repo.dart';

class AppointmentService {
  final AppointmentRepository _appointmentRepository;

  AppointmentService(this._appointmentRepository);

  /// Create a new appointment
  Future<Appointment?> createAppointment({
    required String appointmentId,
    required String doctorId,
    required String patientId,
    required DateTime appointmentDateTime,
    String? notes,
  }) async {
    final appointment = Appointment(
      id: appointmentId,
      doctorId: doctorId,
      patientId: patientId,
      appointmentDateTime: appointmentDateTime,
      status: 'scheduled',
      notes: notes,
      createdAt: DateTime.now(),
    );
    return await _appointmentRepository.create(appointment);
  }

  /// Cancel an existing appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    final appointment = await _appointmentRepository.getById(appointmentId);
    if (appointment == null) {
      return false;
    }

    final cancelledAppointment = Appointment(
      id: appointment.id,
      doctorId: appointment.doctorId,
      patientId: appointment.patientId,
      appointmentDateTime: appointment.appointmentDateTime,
      status: 'cancelled',
      notes: appointment.notes,
      diagnosis: appointment.diagnosis,
      createdAt: appointment.createdAt,
    );

    return await _appointmentRepository.update(cancelledAppointment);
  }

  /// Get all appointments for a doctor
  Future<List<Appointment>> getDoctorAppointments(String doctorId) async {
    return await _appointmentRepository.getByDoctorId(doctorId);
  }

  /// Get all appointments for a patient
  Future<List<Appointment>> getPatientAppointments(String patientId) async {
    return await _appointmentRepository.getByPatientId(patientId);
  }

  /// Complete an appointment and add diagnosis
  Future<bool> completeAppointment(
    String appointmentId,
    String diagnosis,
    String? notes,
  ) async {
    final appointment = await _appointmentRepository.getById(appointmentId);
    if (appointment == null) {
      return false;
    }

    final completedAppointment = Appointment(
      id: appointment.id,
      doctorId: appointment.doctorId,
      patientId: appointment.patientId,
      appointmentDateTime: appointment.appointmentDateTime,
      status: 'completed',
      notes: notes ?? appointment.notes,
      diagnosis: diagnosis,
      createdAt: appointment.createdAt,
    );

    return await _appointmentRepository.update(completedAppointment);
  }

  /// Get upcoming appointments within a date range
  Future<List<Appointment>> getUpcomingAppointments(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _appointmentRepository.getByDateRange(startDate, endDate);
  }

  /// Get appointments by status
  Future<List<Appointment>> getByStatus(String status) async {
    return await _appointmentRepository.getByStatus(status);
  }
}
