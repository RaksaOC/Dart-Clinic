import 'package:test/test.dart';
import 'package:dart_clinic/services/session_service.dart';

void registerSessionServiceTests() {
  setUp(() {
    SessionService().logout();
  });

  group('SessionService', () {
    test('loginDoctor authenticates valid credentials', () {
      final session = SessionService();
      final doctor = session.loginDoctor('qw', 'qw');

      expect(doctor, isNotNull);
      expect(session.currentDoctor?.id, equals('D001'));
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

      final manager = session.loginManager(
        'vannak.sok@clinic.kh',
        'manager123',
      );

      expect(manager, isNotNull);
      expect(session.currentDoctor, isNull);
      expect(session.currentManager?.id, equals('M001'));
    });

    test('loginManager authenticates valid credentials', () {
      final session = SessionService();
      final manager = session.loginManager(
        'vannak.sok@clinic.kh',
        'manager123',
      );

      expect(manager, isNotNull);
      expect(session.currentManager?.id, equals('M001'));
    });
  });
}

// Allow running this file independently
void main() {
  setUp(() {
    SessionService().logout();
  });
  registerSessionServiceTests();
}
