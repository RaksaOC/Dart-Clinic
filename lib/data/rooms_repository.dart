import 'base_repository.dart';

class RoomsRepository extends BaseRepository {
  RoomsRepository() : super('rooms');

  Map<String, Object?>? findByRoomNumber(String roomNumber) {
    final list = findAll(
      where: 'room_number = ?',
      params: [roomNumber],
      limit: 1,
    );
    return list.isEmpty ? null : list.first;
  }
}
