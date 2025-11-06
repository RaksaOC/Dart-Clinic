import 'package:test/test.dart';
import 'package:dart_clinic/domain/services/room_service.dart';

void registerRoomServiceTests() {
  group('RoomService', () {
    test('reports accurate availability stats', () {
      final service = RoomService();

      final stats = service.getOccupancyStats();
      expect(stats['totalRooms'], greaterThan(0));
      expect(stats.containsKey('availableRooms'), isTrue);
    });

    test('fetches room details by id', () {
      final service = RoomService();

      final room = service.getRoomById(
        '8b326d82-f779-4630-aa3c-c84b40e664cf',
      ); // R002

      expect(room, isNotNull);
      expect(room!.roomNumber, equals('102'));
    });

    test('available rooms list matches occupancy status', () {
      final service = RoomService();

      final availableRooms = service.getAvailableRooms();

      expect(availableRooms.every((room) => room.isOccupied == false), isTrue);
      expect(
        availableRooms.length,
        equals(service.getOccupancyStats()['availableRooms']),
      );
    });

    test('get all rooms returns seeded inventory', () {
      final service = RoomService();

      final rooms = service.getAllRooms();

      expect(rooms.length, greaterThanOrEqualTo(6));
    });
  });
}

// Allow running this file independently
void main() {
  registerRoomServiceTests();
}
