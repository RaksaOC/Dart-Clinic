/// Admin Repository
///
/// Responsible for data persistence operations for admins.
/// Handles CRUD operations for admin entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/admin.dart';

class AdminRepository extends RepositoryBase<Admin> {
  AdminRepository() : super('lib/db/admins.json');

  @override
  Map<String, dynamic> toJson(Admin entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'email': entity.email,
      'password': entity.password, // In production, this should be hashed
    };
  }

  @override
  Admin fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// Find admin by email
  Future<Admin?> findByEmail(String email) async {
    final admins = await loadAll();
    try {
      return admins.firstWhere((admin) => admin.email == email);
    } catch (e) {
      return null;
    }
  }
}
