/// Room Repository
///
/// Responsible for data persistence operations for rooms.
/// Handles CRUD operations for room entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/room.dart';

class RoomRepository extends RepositoryBase<Room> {
  RoomRepository() : super('lib/db/rooms.json');

  @override
  Map<String, dynamic> toJson(Room entity) {
    return {
      'id': entity.id,
      'roomNumber': entity.roomNumber,
      'roomType': entity.roomType,
      'totalBeds': entity.totalBeds,
      'occupiedBeds': entity.occupiedBeds,
      'dailyRate': entity.dailyRate,
      'isAvailable': entity.isAvailable,
      'notes': entity.notes,
    };
  }

  @override
  Room fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      roomNumber: json['roomNumber'] as String,
      roomType: json['roomType'] as String,
      totalBeds: json['totalBeds'] as int,
      occupiedBeds: json['occupiedBeds'] as int,
      dailyRate: (json['dailyRate'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      notes: json['notes'] as String?,
    );
  }

  /// Get rooms by type
  Future<List<Room>> getByType(String roomType) async {
    final rooms = await loadAll();
    return rooms.where((room) => room.roomType == roomType).toList();
  }
}
