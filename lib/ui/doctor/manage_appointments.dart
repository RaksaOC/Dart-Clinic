/// Manage Appointments UI
///
/// Provides CLI interface for appointment management operations for doctors.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/appointment.dart';
import '../../domain/controllers/doctor/appointments_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';
import '../../domain/controllers/doctor/patients_controller.dart';

class ManageAppointments {
  final AppointmentsController _controller;

  ManageAppointments() : _controller = AppointmentsController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE APPOINTMENTS');
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
          TerminalUI.pauseAndClear();
          break;
        case 'View My Appointments':
          _viewMyAppointmentsMenu();
          TerminalUI.pauseAndClear();
          break;
        case 'View Appointment Details':
          _viewAppointmentDetails();
          TerminalUI.pauseAndClear();
          break;
        case 'Cancel Appointment':
          _cancelAppointment();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Doctor Dashboard':
          return;
      }
    }
  }

  void _createAppointment() {
    print('\nCREATE APPOINTMENT');
    print('-' * 50);

    try {
      // Select patient from list
      final patientsController = PatientsController();
      final patients = patientsController.getAllPatients();
      if (patients.isEmpty) {
        print('\nNo patients found.');
        return;
      }
      final patientOptions = formatCardOptions(patients);
      final chosenPatient = prompts.choose('Select a patient:', patientOptions);
      final pIdx = patientOptions.indexOf(chosenPatient!);
      final patientId = patients[pIdx].id;
      final dateStr = prompts.get('Date & Time (YYYY-MM-DD HH:MM, 24h):');
      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final dateTime = DateTime.tryParse(dateStr.replaceFirst(' ', 'T'));

      if (dateTime == null) {
        print('\n❌ Invalid date format.');
        return;
      }

      final created = _controller.createAppointment(
        patientId: patientId.trim(),
        appointmentDateTime: dateTime,
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (created != null) {
        print('\nAppointment created successfully.');
        print('ID: ${created.id}');
        print('Patient: ${created.patientId}');
        print('When: ${created.appointmentDateTime}');
      } else {
        print('\nFailed to create appointment. Ensure patient exists.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewMyAppointmentsMenu() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '-' * 50);
      print('VIEW MY APPOINTMENTS');
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
          final lines = formatCardOptions(_controller.getMyAppointments());
          for (final line in lines) {
            print(line);
          }
          TerminalUI.pauseAndClear();
          break;
        case "Today's Appointments":
          final now = DateTime.now();
          final startOfDay = DateTime(now.year, now.month, now.day);
          final endOfDay = startOfDay.add(const Duration(days: 1));
          final lines = formatCardOptions(
            _controller.getMyUpcomingAppointments(startOfDay, endOfDay),
          );
          for (final line in lines) {
            print(line);
          }
          TerminalUI.pauseAndClear();
          break;
        case 'Upcoming Appointments':
          final now = DateTime.now();
          final end = now.add(const Duration(days: 30));
          final lines = formatCardOptions(
            _controller.getMyUpcomingAppointments(now, end),
          );
          for (final line in lines) {
            print(line);
          }
          TerminalUI.pauseAndClear();
          break;
        case 'Past Appointments':
          final now2 = DateTime.now();
          final lines = formatCardOptions(
            _controller
                .getMyAppointments()
                .where((a) => a.appointmentDateTime.isBefore(now2))
                .toList(),
          );
          for (final line in lines) {
            print(line);
          }
          TerminalUI.pauseAndClear();
          break;
        case 'Back':
          return;
      }
    }
  }

  void _viewAppointmentDetails() {
    print('\nVIEW APPOINTMENT DETAILS');
    print('-' * 50);
    final list = _controller.getMyAppointments();
    if (list.isEmpty) {
      print('\nNo appointments.');
      return;
    }

    final options = formatCardOptions(list);
    final chosen = prompts.choose('Select an appointment:', options);
    final idx = options.indexOf(chosen!);
    final appointment = list[idx];

    final lines = formatCardOptions([appointment]);
    for (final line in lines) {
      print(line);
    }

    final action = prompts.choose('Actions:', ['Complete Appointment', 'Back']);

    if (action == 'Complete Appointment') {
      final diagnosis = prompts.get('Diagnosis:');
      final notes = prompts.get('Notes (optional):');
      final ok = _controller.completeAppointment(
        appointmentId: appointment.id,
        diagnosis: diagnosis.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );
      if (ok) {
        print('\nAppointment completed.');
        final askRx = prompts.getBool('Issue Prescription now? (y/n)');
        if (askRx) {
          // handled by prescriptions module from doctor menu
          print('\nGo to Manage Prescriptions > Issue Prescription');
        }
      } else {
        print('\nFailed to complete appointment.');
      }
    }
  }

  void _cancelAppointment() {
    print('\nCANCEL APPOINTMENT');
    print('-' * 50);
    final appts = _controller.getMyAppointments();
    if (appts.isEmpty) {
      print('\nNo appointments.');
      return;
    }

    final options = formatCardOptions(appts);
    final chosen = prompts.choose('Select an appointment to cancel:', options);
    final idx = options.indexOf(chosen!);
    final appt = appts[idx];

    // Business rule: only cancel if >24h in future
    final now = DateTime.now();
    if (!appt.appointmentDateTime.isAfter(now.add(const Duration(hours: 24)))) {
      print('\n❌ Can only cancel appointments more than 24 hours in advance.');
      return;
    }

    final confirm = prompts.getBool('Confirm cancel? (y/n)');
    if (!confirm) return;

    final ok = _controller.cancelAppointment(appt.id);
    if (ok) {
      print('\nAppointment cancelled.');
    } else {
      print('\nFailed to cancel appointment.');
    }
  }
}
