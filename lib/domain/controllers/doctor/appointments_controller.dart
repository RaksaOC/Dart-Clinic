/// Appointments Controller (Doctor)
library;

import '../../services/appointment_service.dart';
import '../../services/patient_service.dart';
import '../../../domain/models/appointment.dart';
import '../../../domain/models/status.dart';
import '../../../domain/models/patient.dart';

class AppointmentsController {
  final AppointmentService _appointmentService;
  final PatientService _patientService;

  AppointmentsController({
    AppointmentService? appointmentService,
    PatientService? patientService,
  }) : _appointmentService = appointmentService ?? AppointmentService(),
       _patientService = patientService ?? PatientService();

  AppointmentModel? createAppointment({
    required String patientId,
    required DateTime appointmentDateTime,
    String? notes,
  }) {
    final PatientModel? patient = _patientService.getPatientById(patientId);
    if (patient == null) return null;
    return _appointmentService.createAppointment(
      patientId: patientId,
      appointmentDateTime: appointmentDateTime,
      notes: notes,
    );
  }

  List<AppointmentModel> getMyAppointments() {
    return _appointmentService.getMyAppointments();
  }

  AppointmentModel? getAppointmentById(String appointmentId) {
    return _appointmentService.getById(appointmentId);
  }

  bool cancelAppointment(String appointmentId) {
    return _appointmentService.cancelAppointment(appointmentId);
  }

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

  List<AppointmentModel> getMyUpcomingAppointments(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _appointmentService.getMyUpcomingAppointments(startDate, endDate);
  }

  List<AppointmentModel> getMyAppointmentsByStatus(AppointmentStatus status) {
    return _appointmentService.getMyAppointmentsByStatus(status);
  }
}
