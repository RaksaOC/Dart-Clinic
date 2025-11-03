/// Bed Service
///
/// Handles business logic for bed management including:
/// - Assigning patients to beds
/// - Checking bed availability
/// - Managing bed occupancy
///
/// Coordinates between the UI layer and bed repository.
library;

import '../domain/bed.dart';
import '../data/bed_repo.dart';

class BedService {
  final BedRepository _bedRepository;

  BedService(this._bedRepository);

  /// Get all beds
  Future<List<Bed>> getAllBeds() async {
    return await _bedRepository.getAll();
  }

  /// Get beds by room ID
  Future<List<Bed>> getBedsByRoomId(String roomId) async {
    return await _bedRepository.getBedsByRoomId(roomId);
  }

  /// Get available beds
  Future<List<Bed>> getAvailableBeds() async {
    final beds = await _bedRepository.getAll();
    return beds.where((bed) => !bed.isOccupied).toList();
  }

  /// Assign a patient to a bed
  Future<bool> assignPatientToBed({
    required String bedId,
    required String patientId,
  }) async {
    final bed = await _bedRepository.getById(bedId);
    if (bed == null || bed.isOccupied) {
      return false;
    }

    final assignedBed = Bed(
      id: bed.id,
      roomId: bed.roomId,
      bedNumber: bed.bedNumber,
      isOccupied: true,
      patientId: patientId,
      occupiedSince: DateTime.now(),
      checkoutDate: bed.checkoutDate,
    );

    return await _bedRepository.update(assignedBed);
  }

  /// Release a bed (patient checkout)
  Future<bool> releaseBed(String bedId) async {
    final bed = await _bedRepository.getById(bedId);
    if (bed == null || !bed.isOccupied) {
      return false;
    }

    final releasedBed = Bed(
      id: bed.id,
      roomId: bed.roomId,
      bedNumber: bed.bedNumber,
      isOccupied: false,
      patientId: null,
      occupiedSince: bed.occupiedSince,
      checkoutDate: DateTime.now(),
    );

    return await _bedRepository.update(releasedBed);
  }

  /// Get bed by ID
  Future<Bed?> getBedById(String bedId) async {
    return await _bedRepository.getById(bedId);
  }
}
