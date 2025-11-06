/// AdmissionModel Service
///
/// Handles business logic for patient admissions including:
/// - Admitting patients to rooms
/// - Discharging patients
/// - Managing admission records
///
/// Coordinates between the UI layer and admission/room repositories.
library;

import 'package:dart_clinic/domain/models/room.dart';
import 'package:dart_clinic/domain/models/status.dart';

import '../models/admission.dart';
import '../../data/admission_repo.dart';
import '../../data/room_repo.dart';
import 'package:uuid/uuid.dart';

class AdmissionService {
  final AdmissionRepository _admissionRepository;
  final RoomRepository _roomRepository;

  AdmissionService([
    AdmissionRepository? admissionRepository,
    RoomRepository? roomRepository,
  ]) : _admissionRepository = admissionRepository ?? AdmissionRepository(),
       _roomRepository = roomRepository ?? RoomRepository();

  /// Admit a patient to a room
  AdmissionModel? admitPatient({
    required String patientId,
    required String roomId,
    String? notes,
  }) {
    // Uniqueness check
    final String id = const Uuid().v4();
    if (_admissionRepository.getById(id) != null) {
      return null;
    }
    // Check if room is available
    final room = _roomRepository.getById(roomId);
    if (room == null || room.isOccupied) {
      return null;
    }

    // Check if patient already has an active admission
    final activeAdmission = getActiveByPatientId(patientId);
    if (activeAdmission != null) {
      return null; // Patient already admitted
    }

    // Create admission record
    final admission = AdmissionModel(
      id: id,
      patientId: patientId,
      roomId: roomId,
      admissionDate: DateTime.now(),
      status: AdmissionStatus.active,
      notes: notes,
    );

    // Update room to occupied
    final occupiedRoom = RoomModel(
      id: room.id,
      roomNumber: room.roomNumber,
      roomType: room.roomType,
      dailyRate: room.dailyRate,
      isOccupied: true,
      patientId: patientId,
      notes: room.notes,
    );

    _roomRepository.update(occupiedRoom);
    return _admissionRepository.create(admission);
  }

  /// Discharge a patient
  bool dischargePatient(String admissionId) {
    final admission = _admissionRepository.getById(admissionId);
    if (admission == null || admission.status != AdmissionStatus.active) {
      return false;
    }

    // Update admission to discharged
    final dischargedAdmission = AdmissionModel(
      id: admission.id,
      patientId: admission.patientId,
      roomId: admission.roomId,
      admissionDate: admission.admissionDate,
      dischargeDate: DateTime.now(),
      status: AdmissionStatus.discharged,
      notes: admission.notes,
    );

    // Update room to available
    final room = _roomRepository.getById(admission.roomId);
    if (room != null) {
      final availableRoom = RoomModel(
        id: room.id,
        roomNumber: room.roomNumber,
        roomType: room.roomType,
        dailyRate: room.dailyRate,
        isOccupied: false,
        patientId: null,
        notes: room.notes,
      );
      _roomRepository.update(availableRoom);
    }

    return _admissionRepository.update(dischargedAdmission);
  }

  /// Get all admissions
  List<AdmissionModel> getAllAdmissions() {
    return _admissionRepository.getAll();
  }

  /// Get admissions by patient ID
  List<AdmissionModel> getAdmissionsByPatientId(String patientId) {
    final admissions = _admissionRepository.getAll();
    return admissions
        .where((admission) => admission.patientId == patientId)
        .toList();
  }

  /// Get admissions by room ID
  List<AdmissionModel> getAdmissionsByRoomId(String roomId) {
    final admissions = _admissionRepository.getAll();
    return admissions.where((admission) => admission.roomId == roomId).toList();
  }

  /// Get active admissions
  List<AdmissionModel> getActiveAdmissions() {
    final admissions = _admissionRepository.getAll();
    return admissions.where((a) => a.status == AdmissionStatus.active).toList();
  }

  /// Get active admission for a patient
  AdmissionModel? getActiveByPatientId(String patientId) {
    final admissions = getAdmissionsByPatientId(patientId);
    try {
      return admissions.firstWhere((a) => a.status == AdmissionStatus.active);
    } catch (e) {
      return null;
    }
  }

  /// Get admission by id
  AdmissionModel? getById(String id) {
    return _admissionRepository.getById(id);
  }
}
