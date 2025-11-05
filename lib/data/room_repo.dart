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
      'dailyRate': entity.dailyRate,
      'isOccupied': entity.isOccupied,
      'patientId': entity.patientId,
      'notes': entity.notes,
    };
  }

  @override
  Room fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      roomNumber: json['roomNumber'] as String,
      roomType: json['roomType'] as String,
      dailyRate: (json['dailyRate'] as num).toDouble(),
      isOccupied: json['isOccupied'] as bool,
      patientId: json['patientId'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
