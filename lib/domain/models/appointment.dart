/// Appointment domain model
///
/// Represents an appointment between a doctor and a patient
/// with scheduling information and status tracking.
library;

class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime appointmentDateTime;
  final String status; // scheduled, completed, cancelled, missed
  final String? notes;
  final String? diagnosis;
  final DateTime? createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDateTime,
    required this.status,
    this.notes,
    this.diagnosis,
    this.createdAt,
  });

  /// TODO: Add method to check if appointment is upcoming
  bool isUpcoming() {
    // TODO: Implement logic to check if appointment is in the future
    return false;
  }

  /// TODO: Add method to check if appointment can be cancelled
  bool canCancel() {
    // TODO: Implement business rules for cancellation
    return false;
  }

  /// TODO: Add method to get appointment details as JSON
  Map<String, dynamic> toJson() {
    // TODO: Implement JSON serialization
    return {};
  }

  /// TODO: Add factory method to create Appointment from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    // TODO: Implement JSON deserialization
    return Appointment(
      id: '',
      doctorId: '',
      patientId: '',
      appointmentDateTime: DateTime.now(),
      status: '',
    );
  }
}
