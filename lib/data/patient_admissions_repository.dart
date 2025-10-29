import 'base_repository.dart';

class PatientAdmissionsRepository extends BaseRepository {
  PatientAdmissionsRepository() : super('patient_admissions');

  List<Map<String, Object?>> findActiveByPatient(int patientId) {
    return findAll(
      where: 'patient_id = ? AND discharged_at IS NULL',
      params: [patientId],
      orderBy: 'admitted_at DESC',
    );
  }
}
