/// Room domain model
///
/// Represents a room in the hospital. One room = one patient (no wards).
library;

class RoomModel {
  final String id;
  final String roomNumber;
  final String roomType; // general, private, ICU, emergency
  final double dailyRate;
  final bool isOccupied;
  final String? patientId; // ID of patient currently in this room (if occupied)
  final String? notes;

  RoomModel({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.dailyRate,
    required this.isOccupied,
    this.patientId,
    this.notes,
  });
}
