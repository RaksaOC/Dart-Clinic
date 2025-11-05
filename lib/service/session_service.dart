/// Session Service (Singleton)
///
/// Manages application session state and authentication for doctors and managers.
library;

import '../domain/models/doctor.dart';
import '../domain/models/manager.dart';
import 'doctor_service.dart';
import 'manager_service.dart';

class SessionService {
  // Singleton boilerplate
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  DoctorModel? _currentDoctor;
  ManagerModel? _currentManager;

  DoctorModel? get currentDoctor => _currentDoctor;
  ManagerModel? get currentManager => _currentManager;

  bool get isDoctorLoggedIn => _currentDoctor != null;
  bool get isManagerLoggedIn => _currentManager != null;

  /// Login as doctor using email/password
  /// Returns the authenticated DoctorModel or null if invalid
  DoctorModel? loginDoctor(String email, String password) {
    final doctors = DoctorService().getAllDoctors();
    try {
      final doctor = doctors.firstWhere(
        (d) => d.email == email && d.password == password,
      );

      _currentDoctor = doctor;
      _currentManager = null;
      return doctor;
    } catch (_) {
      return null;
    }
  }

  /// Login as manager using email/password
  /// Returns the authenticated ManagerModel or null if invalid
  ManagerModel? loginManager(String email, String password) {
    final manager = ManagerService().authenticateManager(email, password);
    if (manager != null) {
      _currentManager = manager;
      _currentDoctor = null; // ensure only one role active
    }
    return manager;
  }

  /// Clear current session (logout)
  void logout() {
    _currentDoctor = null;
    _currentManager = null;
  }
}
