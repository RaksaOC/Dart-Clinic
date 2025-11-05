/// Manage Appointments UI
///
/// Provides CLI interface for appointment management operations for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/appointment.dart';
import '../../domain/usecases/doctor.dart';

class ManageAppointments {
  final Doctor _doctor;

  ManageAppointments() : _doctor = Doctor();

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('📅 MANAGE APPOINTMENTS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Create Appointment',
        'View My Appointments',
        'View Appointment Details',
        'Cancel Appointment',
        'Back to Doctor Dashboard',
      ]);

      switch (choice) {
        case 'Create Appointment':
          _createAppointment();
          break;
        case 'View My Appointments':
          _viewMyAppointmentsMenu();
          break;
        case 'View Appointment Details':
          _viewAppointmentDetails();
          break;
        case 'Cancel Appointment':
          _cancelAppointment();
          break;
        case 'Back to Doctor Dashboard':
          return;
      }
    }
  }

  void _createAppointment() {
    print('\n📝 CREATE APPOINTMENT');
    print('-' * 50);

    try {
      final appointmentId = prompts.get('Appointment ID (e.g., AP001):');
      final patientId = prompts.get('Patient ID:');
      final dateStr = prompts.get('Date & Time (YYYY-MM-DD HH:MM, 24h):');
      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final dateTime = DateTime.tryParse(dateStr.replaceFirst(' ', 'T'));

      if (dateTime == null) {
        print('\n❌ Invalid date format.');
        return;
      }

      final created = _doctor.createAppointment(
        appointmentId: appointmentId.trim(),
        patientId: patientId.trim(),
        appointmentDateTime: dateTime,
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (created != null) {
        print('\n✅ Appointment created successfully!');
        print('ID: ${created.id}');
        print('Patient: ${created.patientId}');
        print('When: ${created.appointmentDateTime}');
      } else {
        print('\n❌ Failed to create appointment. Ensure patient exists.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewMyAppointmentsMenu() {
    while (true) {
      print('\n' + '-' * 50);
      print('📅 VIEW MY APPOINTMENTS');
      print('-' * 50);

      final choice = prompts.choose('Choose a view:', [
        'All Appointments',
        "Today's Appointments",
        'Upcoming Appointments',
        'Past Appointments',
        'Back',
      ]);

      switch (choice) {
        case 'All Appointments':
          _displayAppointments(_doctor.getMyAppointments());
          break;
        case "Today's Appointments":
          _displayAppointments(_doctor.getTodaysAppointments());
          break;
        case 'Upcoming Appointments':
          final now = DateTime.now();
          final end = now.add(const Duration(days: 30));
          _displayAppointments(_doctor.getUpcomingAppointments(now, end));
          break;
        case 'Past Appointments':
          _displayAppointments(_doctor.getPastAppointments());
          break;
        case 'Back':
          return;
      }
    }
  }

  void _viewAppointmentDetails() {
    print('\n🔎 VIEW APPOINTMENT DETAILS');
    print('-' * 50);
    final id = prompts.get('Appointment ID:');
    final appointment = _doctor.getAppointmentById(id.trim());
    if (appointment == null) {
      print('\n❌ Appointment not found for you.');
      return;
    }

    _displayAppointments([appointment]);

    final action = prompts.choose('Actions:', ['Complete Appointment', 'Back']);

    if (action == 'Complete Appointment') {
      final diagnosis = prompts.get('Diagnosis:');
      final notes = prompts.get('Notes (optional):');
      final ok = _doctor.completeAppointment(
        appointmentId: appointment.id,
        diagnosis: diagnosis.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );
      if (ok) {
        print('\n✅ Appointment completed.');
        final askRx = prompts.getBool('Issue Prescription now? (y/n)');
        if (askRx) {
          // handled by prescriptions module from doctor menu
          print('\n➡️  Go to Manage Prescriptions > Issue Prescription');
        }
      } else {
        print('\n❌ Failed to complete appointment.');
      }
    }
  }

  void _cancelAppointment() {
    print('\n❌ CANCEL APPOINTMENT');
    print('-' * 50);
    final id = prompts.get('Appointment ID:');
    final appt = _doctor.getAppointmentById(id.trim());
    if (appt == null) {
      print('\n❌ Appointment not found for you.');
      return;
    }

    // Business rule: only cancel if >24h in future
    final now = DateTime.now();
    if (!appt.appointmentDateTime.isAfter(now.add(const Duration(hours: 24)))) {
      print('\n❌ Can only cancel appointments more than 24 hours in advance.');
      return;
    }

    final confirm = prompts.getBool('Confirm cancel? (y/n)');
    if (!confirm) return;

    final ok = _doctor.cancelAppointment(id.trim());
    if (ok) {
      print('\n✅ Appointment cancelled.');
    } else {
      print('\n❌ Failed to cancel appointment.');
    }
  }

  void _displayAppointments(List<AppointmentModel> appts) {
    if (appts.isEmpty) {
      print('\nNo appointments.');
      return;
    }
    print(
      '\n${'ID'.padRight(10)} ${'Patient'.padRight(10)} ${'When'.padRight(20)} ${'Status'.padRight(12)}',
    );
    print('-' * 70);
    for (final a in appts) {
      print(
        '${a.id.padRight(10)} ${a.patientId.padRight(10)} ${a.appointmentDateTime.toString().padRight(20)} ${a.status.name.padRight(12)}',
      );
    }
  }
}
