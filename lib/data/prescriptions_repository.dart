import 'base_repository.dart';

class PrescriptionsRepository extends BaseRepository {
  PrescriptionsRepository() : super('prescriptions');

  List<Map<String, Object?>> findByPatient(int patientId) {
    return findAll(
      where: 'patient_id = ?',
      params: [patientId],
      orderBy: 'created_at DESC',
    );
  }
}
