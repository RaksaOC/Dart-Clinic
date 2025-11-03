/// Room Service
///
/// Handles business logic for room management including:
/// - Checking room availability
/// - Managing room occupancy
/// - Calculating room utilization rates
///
/// Coordinates between the UI layer and room repository.
library;

import '../domain/room.dart';
import '../data/room_repo.dart';

class RoomService {
  final RoomRepository _roomRepository;

  RoomService(this._roomRepository);

  /// Get all available rooms
  Future<List<Room>> getAvailableRooms() async {
    final rooms = await _roomRepository.getAll();
    return rooms.where((room) => room.isAvailable).toList();
  }

  /// Get all rooms
  Future<List<Room>> getAllRooms() async {
    return await _roomRepository.getAll();
  }

  /// Get rooms by type
  Future<List<Room>> getRoomsByType(String roomType) async {
    return await _roomRepository.getByType(roomType);
  }

  /// Get room by ID
  Future<Room?> getRoomById(String roomId) async {
    return await _roomRepository.getById(roomId);
  }

  /// Get occupancy statistics
  Future<Map<String, dynamic>> getOccupancyStats() async {
    final rooms = await _roomRepository.getAll();

    int totalRooms = rooms.length;
    int totalBeds = 0;
    int occupiedBeds = 0;

    for (var room in rooms) {
      totalBeds += room.totalBeds;
      occupiedBeds += room.occupiedBeds;
    }

    final overallOccupancy = totalBeds > 0
        ? (occupiedBeds / totalBeds) * 100
        : 0.0;

    return {
      'totalRooms': totalRooms,
      'totalBeds': totalBeds,
      'occupiedBeds': occupiedBeds,
      'availableBeds': totalBeds - occupiedBeds,
      'overallOccupancy': overallOccupancy,
    };
  }
}
