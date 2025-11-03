/// Admin domain model
///
/// Represents an administrator in the hospital system with access to
/// system-wide management operations.
library;

class Admin {
  final String id;
  final String name;
  final String email;
  final String password;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Validate admin credentials
  bool validateCredentials(String email, String password) {
    return this.email == email && this.password == password;
  }

  /// TODO: Add method to get admin's full profile
  Map<String, dynamic> toJson() {
    // TODO: Implement JSON serialization
    return {};
  }

  /// TODO: Add factory method to create Admin from JSON
  factory Admin.fromJson(Map<String, dynamic> json) {
    // TODO: Implement JSON deserialization
    return Admin(id: '', name: '', email: '', password: '');
  }
}
