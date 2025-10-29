import 'base_repository.dart';

class PrescriptionMedicationsRepository extends BaseRepository {
  PrescriptionMedicationsRepository() : super('prescription_medications');

  List<Map<String, Object?>> findByPrescription(int prescriptionId) {
    return findAll(
      where: 'prescription_id = ?',
      params: [prescriptionId],
      orderBy: 'id ASC',
    );
  }
}
