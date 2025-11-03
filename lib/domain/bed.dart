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

  /// TODO: Add method to check if bed is available
  bool isAvailable() {
    // TODO: Implement logic to check availability
    return false;
  }

  /// TODO: Add method to calculate bed occupancy duration
  int getOccupancyDurationDays() {
    // TODO: Implement calculation for days occupied
    return 0;
  }

  /// TODO: Add method to get bed details as JSON
  Map<String, dynamic> toJson() {
    // TODO: Implement JSON serialization
    return {};
  }

  /// TODO: Add factory method to create Bed from JSON
  factory Bed.fromJson(Map<String, dynamic> json) {
    // TODO: Implement JSON deserialization
    return Bed(id: '', roomId: '', bedNumber: '', isOccupied: false);
  }
}
