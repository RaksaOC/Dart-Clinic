/// RoomModel Service
///
/// Handles business logic for room management including:
/// - Checking room availability
/// - Managing room occupancy
/// - Calculating room utilization rates
///
/// Coordinates between the UI layer and room repository.
library;

import '../models/room.dart';
import '../../data/room_repo.dart';
import 'package:uuid/uuid.dart';

class RoomService {
  final RoomRepository _roomRepository;

  RoomService([RoomRepository? repository])
    : _roomRepository = repository ?? RoomRepository();

  /// Get all available rooms
  List<RoomModel> getAvailableRooms() {
    final rooms = _roomRepository.getAll();
    return rooms.where((room) => !room.isOccupied).toList();
  }

  /// Get all rooms
  List<RoomModel> getAllRooms() {
    return _roomRepository.getAll();
  }

  /// Get rooms by type
  List<RoomModel> getRoomsByType(String roomType) {
    final rooms = _roomRepository.getAll();
    return rooms.where((room) => room.roomType == roomType).toList();
  }

  /// Get room by ID
  RoomModel? getRoomById(String roomId) {
    return _roomRepository.getById(roomId);
  }

  /// Create a new room
  RoomModel? createRoom({
    required String roomNumber,
    required String roomType,
    required double dailyRate,
    String? notes,
  }) {
    final String id = const Uuid().v4();
    // Uniqueness check
    if (_roomRepository.getById(id) != null) {
      return null;
    }
    final room = RoomModel(
      id: id,
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

  /// Update existing room
  bool updateRoom(RoomModel room) {
    return _roomRepository.update(room);
  }

  /// Delete room by id
  bool deleteRoom(String roomId) {
    return _roomRepository.delete(roomId);
  }
}
