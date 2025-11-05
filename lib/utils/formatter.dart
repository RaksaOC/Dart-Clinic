// Provides formatting helpers for rendering domain models as single-line
// "card-like" option strings suitable for CLI selection menus.
library;

import 'package:dart_clinic/domain/models/doctor.dart';
import 'package:dart_clinic/domain/models/patient.dart';
import 'package:dart_clinic/domain/models/manager.dart';
import 'package:dart_clinic/domain/models/room.dart';
import 'package:dart_clinic/domain/models/appointment.dart';
import 'package:dart_clinic/domain/models/prescription.dart';
import 'package:dart_clinic/domain/models/admission.dart';

String _formatDateTime(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$y-$m-$d $hh:$mm';
}

String _joinParts(List<String> parts) {
  return parts.where((p) => p.trim().isNotEmpty).join('  |  ');
}

String _doctorCard(DoctorModel d) {
  return _joinParts([
    'ID: ${d.id}',
    d.name,
    'Spec: ${d.specialization}',
    d.email,
  ]);
}

String _patientCard(PatientModel p) {
  return _joinParts([
    'ID: ${p.id}',
    p.name,
    'Age: ${p.age}',
    'Gender: ${p.gender}',
    p.email,
  ]);
}

String _managerCard(ManagerModel m) {
  return _joinParts(['ID: ${m.id}', m.name, m.email]);
}

String _roomCard(RoomModel r) {
  final status = r.isOccupied ? 'Occupied' : 'Available';
  final pid = r.patientId ?? 'N/A';
  return _joinParts([
    'ID: ${r.id}',
    'Room: ${r.roomNumber}',
    'Type: ${r.roomType}',
    'Rate: ${r.dailyRate.toStringAsFixed(2)}',
    'Status: $status',
    'Patient: $pid',
  ]);
}

String _appointmentCard(AppointmentModel a) {
  return _joinParts([
    'ID: ${a.id}',
    'Patient: ${a.patientId}',
    'When: ${_formatDateTime(a.appointmentDateTime)}',
    'Status: ${a.status.name}',
  ]);
}

String _prescriptionCard(PrescriptionModel p) {
  return _joinParts([
    'ID: ${p.id}',
    'Patient: ${p.patientId}',
    'Med: ${p.medicationName}',
    'Dose: ${p.dosage}',
    'Dur: ${p.durationDays}d',
  ]);
}

String _admissionCard(AdmissionModel a) {
  final discharge = a.dischargeDate != null
      ? _formatDateTime(a.dischargeDate!)
      : 'N/A';
  return _joinParts([
    'ID: ${a.id}',
    'Patient: ${a.patientId}',
    'Room: ${a.roomId}',
    'Status: ${a.status.name}',
    'Admit: ${_formatDateTime(a.admissionDate)}',
    'Discharge: $discharge',
  ]);
}

/// Format a single model instance into a one-line card string.
String formatCard(dynamic item) {
  if (item is DoctorModel) return _doctorCard(item);
  if (item is PatientModel) return _patientCard(item);
  if (item is ManagerModel) return _managerCard(item);
  if (item is RoomModel) return _roomCard(item);
  if (item is AppointmentModel) return _appointmentCard(item);
  if (item is PrescriptionModel) return _prescriptionCard(item);
  if (item is AdmissionModel) return _admissionCard(item);
  // Fallback: best-effort toString
  return item.toString();
}

/// Format a list of model instances into card strings (for prompts.choose options).
List<String> formatCardOptions<T>(List<T> items) {
  final options = <String>[];
  for (final item in items) {
    options.add(formatCard(item));
  }
  return options;
}
