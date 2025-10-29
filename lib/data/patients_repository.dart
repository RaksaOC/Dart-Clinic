import 'base_repository.dart';

class PatientsRepository extends BaseRepository {
  PatientsRepository() : super('patients');

  List<Map<String, Object?>> searchByName(String query) {
    return findAll(
      where: 'full_name LIKE ?',
      params: ['%$query%'],
      orderBy: 'full_name ASC',
    );
  }
}
