import 'package:test/test.dart';
import 'package:dart_clinic/domain/services/session_service.dart';

void registerSessionServiceTests() {
  setUp(() {
    SessionService().logout();
  });

  group('SessionService', () {
    test('loginDoctor authenticates valid credentials', () {
      final session = SessionService();
      final doctor = session.loginDoctor('qw', 'qw');

      expect(doctor, isNotNull);
      // D001 (Dara Sovann) -> a054226d-cad4-427e-b571-a8cc60cf5397
      expect(session.currentDoctor?.id, equals('a054226d-cad4-427e-b571-a8cc60cf5397'));
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
      // M001 (Sok Vannak) -> 38605af8-aa47-4aae-8548-b86e80150793
      expect(session.currentManager?.id, equals('38605af8-aa47-4aae-8548-b86e80150793'));
    });

    test('loginManager authenticates valid credentials', () {
      final session = SessionService();
      final manager = session.loginManager(
        'vannak.sok@clinic.kh',
        'manager123',
      );

      expect(manager, isNotNull);
      // M001 (Sok Vannak) -> 38605af8-aa47-4aae-8548-b86e80150793
      expect(session.currentManager?.id, equals('38605af8-aa47-4aae-8548-b86e80150793'));
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
