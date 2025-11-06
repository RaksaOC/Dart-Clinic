/// Appointments Controller (Doctor)
library;

import '../../services/appointment_service.dart';
import '../../../domain/models/appointment.dart';
import '../../../domain/models/status.dart';

class AppointmentsController {
  final AppointmentService _appointmentService;

  AppointmentsController({AppointmentService? appointmentService})
    : _appointmentService = appointmentService ?? AppointmentService();

  AppointmentModel? createAppointment({
    required String patientId,
    required DateTime appointmentDateTime,
    String? notes,
  }) {
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

  List<AppointmentModel> getMyUpcomingAppointments() {
    return _appointmentService.getMyUpcomingAppointments();
  }

  List<AppointmentModel> getMyPastAppointments() {
    return _appointmentService.getMyPastAppointments();
  }

  List<AppointmentModel> getMyAppointmentsByStatus(AppointmentStatus status) {
    return _appointmentService.getMyAppointmentsByStatus(status);
  }
}
