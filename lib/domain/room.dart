/// Room domain model
///
/// Represents a room in the hospital with capacity information
/// and occupied status tracking.
library;

class Room {
  final String id;
  final String roomNumber;
  final String roomType; // general, private, ICU, emergency
  final int totalBeds;
  final int occupiedBeds;
  final double dailyRate;
  final bool isAvailable;
  final String? notes;

  Room({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.dailyRate,
    required this.isAvailable,
    this.notes,
  });
}
