/// Bed domain model
///
/// Represents an individual bed within a room with occupancy status
/// and patient assignment information.
library;

class Bed {
  final String id;
  final String roomId;
  final String bedNumber; // e.g., "A", "1", "B"
  final bool isOccupied;
  final String? patientId;
  final DateTime? occupiedSince;
  final DateTime? checkoutDate;

  Bed({
    required this.id,
    required this.roomId,
    required this.bedNumber,
    required this.isOccupied,
    this.patientId,
    this.occupiedSince,
    this.checkoutDate,
  });

}
