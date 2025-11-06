import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:dart_clinic/domain/services/session_service.dart';

// Import all test registration functions
import 'session_service_test.dart' show registerSessionServiceTests;
import 'appointment_service_test.dart' show registerAppointmentServiceTests;
import 'prescription_service_test.dart' show registerPrescriptionServiceTests;
import 'admission_service_test.dart' show registerAdmissionServiceTests;
import 'room_service_test.dart' show registerRoomServiceTests;
import 'doctor_service_test.dart' show registerDoctorServiceTests;
import 'manager_service_test.dart' show registerManagerServiceTests;
import 'patient_service_test.dart' show registerPatientServiceTests;

void main() {
  final originalDir = Directory.current;

  setUpAll(() {
    final libDir = Directory(p.join(originalDir.path, 'lib'));
    if (libDir.existsSync()) {
      Directory.current = libDir.path;
    }
  });

  tearDownAll(() {
    Directory.current = originalDir.path;
  });

  setUp(() {
    SessionService().logout();
  });

  // Register and run all test groups
  registerSessionServiceTests();
  registerAppointmentServiceTests();
  registerPrescriptionServiceTests();
  registerAdmissionServiceTests();
  registerRoomServiceTests();
  registerDoctorServiceTests();
  registerManagerServiceTests();
  registerPatientServiceTests();
}