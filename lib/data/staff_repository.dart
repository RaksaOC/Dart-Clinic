import 'base_repository.dart';

class StaffRepository extends BaseRepository {
  StaffRepository() : super('staff');

  Map<String, Object?>? findByUsername(String username) {
    final results = findAll(
      where: 'username = ?',
      params: [username],
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }
}
