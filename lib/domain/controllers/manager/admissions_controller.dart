/// Admissions Controller (Manager)
library;

import '../../../services/admission_service.dart';
import '../../../services/patient_service.dart';
import '../../../services/room_service.dart';
import '../../../domain/models/admission.dart';

class AdmissionsController {
  final AdmissionService _admissionService;
  final PatientService _patientService;
  final RoomService _roomService;

  AdmissionsController({
    AdmissionService? admissionService,
    PatientService? patientService,
    RoomService? roomService,
  }) : _admissionService = admissionService ?? AdmissionService(),
       _patientService = patientService ?? PatientService(),
       _roomService = roomService ?? RoomService();

  AdmissionModel? getById(String id) => _admissionService.getById(id);
  List<AdmissionModel> getAllAdmissions() =>
      _admissionService.getAllAdmissions();
  List<AdmissionModel> getActiveAdmissions() =>
      _admissionService.getActiveAdmissions();
  List<AdmissionModel> getAdmissionsByPatientId(String patientId) =>
      _admissionService.getAdmissionsByPatientId(patientId);
  List<AdmissionModel> getAdmissionsByRoomId(String roomId) =>
      _admissionService.getAdmissionsByRoomId(roomId);
  AdmissionModel? getActiveByPatientId(String patientId) =>
      _admissionService.getActiveByPatientId(patientId);

  AdmissionModel? admitPatient({
    required String patientId,
    required String roomId,
    String? notes,
  }) {
    if (_patientService.getPatientById(patientId) == null) return null;
    if (_roomService.getRoomById(roomId) == null) return null;
    return _admissionService.admitPatient(
      patientId: patientId,
      roomId: roomId,
      notes: notes,
    );
  }

  bool dischargePatient(String admissionId) {
    return _admissionService.dischargePatient(admissionId);
  }
}
