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
}
