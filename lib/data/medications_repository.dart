import 'base_repository.dart';

class MedicationsRepository extends BaseRepository {
  MedicationsRepository() : super('medications');

  List<Map<String, Object?>> lowStock({int threshold = 10}) {
    return findAll(
      where: 'stock_qty <= ?',
      params: [threshold],
      orderBy: 'stock_qty ASC',
    );
  }
}
