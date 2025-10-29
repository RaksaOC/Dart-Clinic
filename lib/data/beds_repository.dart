import 'base_repository.dart';

class BedsRepository extends BaseRepository {
  BedsRepository() : super('beds');

  List<Map<String, Object?>> findByRoom(int roomId) {
    return findAll(
      where: 'room_id = ?',
      params: [roomId],
      orderBy: 'bed_number ASC',
    );
  }

  List<Map<String, Object?>> findAvailableByRoom(int roomId) {
    return findAll(
      where: 'room_id = ? AND status = ?',
      params: [roomId, 'available'],
      orderBy: 'bed_number ASC',
    );
  }
}
