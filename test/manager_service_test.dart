import 'package:test/test.dart';
import 'package:dart_clinic/domain/models/manager.dart';
import 'package:dart_clinic/domain/services/manager_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dart_clinic/domain/services/session_service.dart';

void registerManagerServiceTests() {
  group('ManagerService', () {
    test('creates and deletes manager', () {
      final service = ManagerService();

      final created = service.createManager(
        name: 'Chan Dara',
        email: 'chan.dara@clinic.kh',
        password: 'securePass',
        age: 30,
        gender: 'Male',
        phoneNumber: '+855-11-222-333',
        address: 'Battambang',
      );

      expect(created, isNotNull);
      final deleted = service.deleteManager(created!.id);
      expect(deleted, isTrue);
    });

    test('finds manager by email', () {
      final service = ManagerService();

      final manager = service.findManagerByEmail('vannak.sok@clinic.kh');

      expect(manager, isNotNull);
      // M001 (Sok Vannak) -> 38605af8-aa47-4aae-8548-b86e80150793
      expect(manager!.id, equals('38605af8-aa47-4aae-8548-b86e80150793'));
    });

    test('get all managers returns seed data', () {
      final service = ManagerService();

      final managers = service.getAllManagers();

      // M001 -> 38605af8-aa47-4aae-8548-b86e80150793, M002 -> 87d71eb7-332e-4fb0-bd86-a912bfc30ed7
      expect(managers.map((m) => m.id), containsAll(<String>['38605af8-aa47-4aae-8548-b86e80150793', '87d71eb7-332e-4fb0-bd86-a912bfc30ed7']));
    });

    test('updates existing manager', () {
      final service = ManagerService();

      final created = service.createManager(
        name: 'Temp Manager',
        email: 'temp.manager@clinic.kh',
        password: 'pass123',
        age: 29,
        gender: 'Female',
        phoneNumber: '+855-12-345-000',
        address: 'Phnom Penh',
      );

      expect(created, isNotNull);

      final updated = ManagerModel(
        id: created!.id,
        name: 'Temp Manager Updated',
        email: 'temp.manager@clinic.kh',
        password: created.password, // Keep existing hashed password
        age: 30,
        gender: 'Female',
        phoneNumber: '+855-12-345-000',
        address: 'Phnom Penh',
      );

      final result = service.updateManager(updated);
      expect(result, isTrue);

      service.deleteManager(created.id);
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
  setUp(() {
    SessionService().logout();
  });
  registerManagerServiceTests();
}
