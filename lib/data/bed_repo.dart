/// Bed Repository
///
/// Responsible for data persistence operations for beds.
/// Handles CRUD operations for bed entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/bed.dart';

class BedRepository extends RepositoryBase<Bed> {
  BedRepository() : super('lib/db/beds.json');

  @override
  Map<String, dynamic> toJson(Bed entity) {
    return {
      'id': entity.id,
      'roomId': entity.roomId,
      'bedNumber': entity.bedNumber,
      'isOccupied': entity.isOccupied,
      'patientId': entity.patientId,
      'occupiedSince': entity.occupiedSince?.toIso8601String(),
      'checkoutDate': entity.checkoutDate?.toIso8601String(),
    };
  }

  @override
  Bed fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      bedNumber: json['bedNumber'] as String,
      isOccupied: json['isOccupied'] as bool,
      patientId: json['patientId'] as String?,
      occupiedSince: json['occupiedSince'] != null
          ? DateTime.parse(json['occupiedSince'] as String)
          : null,
      checkoutDate: json['checkoutDate'] != null
          ? DateTime.parse(json['checkoutDate'] as String)
          : null,
    );
  }

  /// Get all beds in a room
  Future<List<Bed>> getBedsByRoomId(String roomId) async {
    final beds = await loadAll();
    return beds.where((bed) => bed.roomId == roomId).toList();
  }
}
