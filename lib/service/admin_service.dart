/// Admin Service
///
/// Handles business logic for admin operations including:
/// - Admin authentication
/// - Managing admin records
///
/// Coordinates between the UI layer and admin repository.
library;

import '../domain/admin.dart';
import '../data/admin_repo.dart';

class AdminService {
  final AdminRepository _adminRepository;

  AdminService(this._adminRepository);

  /// Get all admins
  Future<List<Admin>> getAllAdmins() async {
    return await _adminRepository.getAll();
  }

  /// Get admin by ID
  Future<Admin?> getAdminById(String adminId) async {
    return await _adminRepository.getById(adminId);
  }

  /// Find admin by email
  Future<Admin?> findAdminByEmail(String email) async {
    return await _adminRepository.findByEmail(email);
  }

  /// Authenticate admin
  Future<Admin?> authenticateAdmin(String email, String password) async {
    final admin = await _adminRepository.findByEmail(email);
    if (admin != null && admin.email == email && admin.password == password) {
      return admin;
    }
    return null;
  }

  /// Create a new admin
  Future<Admin?> createAdmin({
    required String adminId,
    required String name,
    required String email,
    required String password,
  }) async {
    final admin = Admin(
      id: adminId,
      name: name,
      email: email,
      password: password,
    );
    return await _adminRepository.create(admin);
  }

  /// Update admin information
  Future<bool> updateAdmin(Admin admin) async {
    return await _adminRepository.update(admin);
  }

  /// Delete an admin
  Future<bool> deleteAdmin(String adminId) async {
    return await _adminRepository.delete(adminId);
  }
}
