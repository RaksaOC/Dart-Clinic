/// Rooms Controller (Manager)
library;

import '../../services/room_service.dart';
import '../../../domain/models/room.dart';

class RoomsController {
  final RoomService _roomService;

  RoomsController({RoomService? roomService})
    : _roomService = roomService ?? RoomService();

  RoomModel? createRoom({
    required String roomNumber,
    required String roomType,
    required double dailyRate,
    String? notes,
  }) {
    return _roomService.createRoom(
      roomNumber: roomNumber,
      roomType: roomType,
      dailyRate: dailyRate,
      notes: notes,
    );
  }

  RoomModel? getRoomById(String id) => _roomService.getRoomById(id);
  List<RoomModel> getAllRooms() => _roomService.getAllRooms();
  List<RoomModel> getAvailableRooms() => _roomService.getAvailableRooms();
  List<RoomModel> getOccupiedRooms() =>
      _roomService.getAllRooms().where((r) => r.isOccupied).toList();
  List<RoomModel> getRoomsByType(String type) =>
      _roomService.getRoomsByType(type);

  bool updateRoom(RoomModel room) => _roomService.updateRoom(room);
  bool deleteRoom(String id) {
    final room = _roomService.getRoomById(id);
    if (room != null && room.isOccupied) return false;
    return _roomService.deleteRoom(id);
  }

  Map<String, dynamic> getOccupancyStats() => _roomService.getOccupancyStats();
}
