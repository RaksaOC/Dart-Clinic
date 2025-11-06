/// Session Service (Singleton)
///
/// Manages application session state and authentication for doctors and managers.
library;

import '../models/doctor.dart';
import '../models/manager.dart';
import 'doctor_service.dart';
import 'manager_service.dart';
import 'package:dart_clinic/utils/password_hasher.dart';

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
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      return null;
    }

    final doctors = DoctorService().getAllDoctors();
    DoctorModel? match;
    for (final d in doctors) {
      if (d.email == trimmedEmail &&
          PasswordHasher.verifyPassword(trimmedPassword, d.password)) {
        match = d;
        break;
      }
    }

    if (match != null) {
      _currentDoctor = match;
      _currentManager = null;
    } else {
      _currentDoctor = null; // ensure no stale session
    }
    return match;
  }

  /// Login as manager using email/password
  /// Returns the authenticated ManagerModel or null if invalid
  ManagerModel? loginManager(String email, String password) {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      return null;
    }

    final managers = ManagerService().getAllManagers();
    ManagerModel? match;
    for (final m in managers) {
      if (m.email == trimmedEmail &&
          PasswordHasher.verifyPassword(trimmedPassword, m.password)) {
        match = m;
        break;
      }
    }

    if (match != null) {
      _currentManager = match;
      _currentDoctor = null;
    } else {
      _currentManager = null; // ensure no stale session
    }
    return match;
  }

  /// Clear current session (logout)
  void logout() {
    _currentDoctor = null;
    _currentManager = null;
  }
}
