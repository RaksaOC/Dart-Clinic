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
  List<Room> getAvailableRooms() {
    final rooms = _roomRepository.getAll();
    return rooms.where((room) => !room.isOccupied).toList();
  }

  /// Get all rooms
  List<Room> getAllRooms() {
    return _roomRepository.getAll();
  }

  /// Get rooms by type
  List<Room> getRoomsByType(String roomType) {
    final rooms = _roomRepository.getAll();
    return rooms.where((room) => room.roomType == roomType).toList();
  }

  /// Get room by ID
  Room? getRoomById(String roomId) {
    return _roomRepository.getById(roomId);
  }

  /// Create a new room
  Room? createRoom({
    required String roomId,
    required String roomNumber,
    required String roomType,
    required double dailyRate,
    String? notes,
  }) {
    final room = Room(
      id: roomId,
      roomNumber: roomNumber,
      roomType: roomType,
      dailyRate: dailyRate,
      isOccupied: false,
      notes: notes,
    );
    return _roomRepository.create(room);
  }

  /// Get occupancy statistics
  Map<String, dynamic> getOccupancyStats() {
    final rooms = _roomRepository.getAll();

    int totalRooms = rooms.length;
    int occupiedRooms = rooms.where((room) => room.isOccupied).length;
    int availableRooms = totalRooms - occupiedRooms;

    final overallOccupancy = totalRooms > 0
        ? (occupiedRooms / totalRooms) * 100
        : 0.0;

    return {
      'totalRooms': totalRooms,
      'occupiedRooms': occupiedRooms,
      'availableRooms': availableRooms,
      'overallOccupancy': overallOccupancy,
    };
  }
}
