import 'base_repository.dart';

class AppointmentsRepository extends BaseRepository {
  AppointmentsRepository() : super('appointments');

  List<Map<String, Object?>> upcomingForDoctor(int doctorId) {
    return findAll(
      where:
          'doctor_id = ? AND status = ? AND appointment_date >= CURRENT_TIMESTAMP',
      params: [doctorId, 'scheduled'],
      orderBy: 'appointment_date ASC',
    );
  }

  List<Map<String, Object?>> byPatient(int patientId) {
    return findAll(
      where: 'patient_id = ?',
      params: [patientId],
      orderBy: 'appointment_date DESC',
    );
  }
}
