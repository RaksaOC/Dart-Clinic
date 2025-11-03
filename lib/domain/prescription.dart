/// Prescription domain model
///
/// Represents a prescription issued by a doctor to a patient
/// with medication details, dosage, and instructions.
library;

class Prescription {
  final String id;
  final String doctorId;
  final String patientId;
  final String medicationName;
  final String dosage;
  final String frequency; // e.g., "twice daily", "as needed"
  final int durationDays;
  final String instructions;
  final DateTime issueDate;
  final String status; // active, completed, cancelled
  final String? notes;

  Prescription({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.instructions,
    required this.issueDate,
    required this.status,
    this.notes,
  });
}
