import 'package:test/test.dart';
import 'package:dart_clinic/domain/services/session_service.dart';
import 'package:dart_clinic/domain/services/doctor_service.dart';
import 'package:dart_clinic/domain/services/manager_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void registerSessionServiceTests() {
  setUp(() {
    SessionService().logout();
  });

  group('SessionService', () {
    test('loginDoctor authenticates valid credentials', () {
      final session = SessionService();
      // Ensure a known doctor exists for this test (independent of seed data)
      DoctorService().createDoctor(
        name: 'Temp Auth Doctor',
        specialization: 'General',
        phoneNumber: '+855-00-000-000',
        email: 'test.doc@clinic.kh',
        address: 'PP',
        age: 30,
        gender: 'Other',
        password: 'authpass',
      );
      final doctor = session.loginDoctor('test.doc@clinic.kh', 'authpass');

      expect(doctor, isNotNull);
      expect(session.currentDoctor, isNotNull);
      expect(session.currentManager, isNull);
    });

    test('logout clears active sessions', () {
      final session = SessionService();
      session.loginDoctor('qw', 'qw');

      session.logout();

      expect(session.currentDoctor, isNull);
      expect(session.currentManager, isNull);
    });

    test('loginDoctor rejects invalid credentials', () {
      final session = SessionService();
      final doctor = session.loginDoctor('invalid@example.com', 'badpass');

      expect(doctor, isNull);
      expect(session.currentDoctor, isNull);
    });

    test('logging in as manager clears doctor session', () {
      final session = SessionService();
      // Ensure a known manager exists for this test
      ManagerService().createManager(
        name: 'Temp Auth Manager',
        email: 'test.manager@clinic.kh',
        password: 'authpass',
        age: 32,
        gender: 'Other',
        phoneNumber: '+855-00-111-222',
        address: 'PP',
      );
      final manager = session.loginManager(
        'test.manager@clinic.kh',
        'authpass',
      );

      expect(manager, isNotNull);
      expect(session.currentDoctor, isNull);
      expect(session.currentManager, isNotNull);
    });

    test('loginManager authenticates valid credentials', () {
      final session = SessionService();
      final manager = session.loginManager(
        'test.manager@clinic.kh',
        'authpass',
      );

      expect(manager, isNotNull);
      expect(session.currentManager, isNotNull);
    });
  });
}

// Allow running this file independently
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
  registerSessionServiceTests();
}
