/// Password Hashing Utility
///
/// Provides secure password hashing using SHA-256.
library;

import 'package:crypto/crypto.dart';
import 'dart:convert';

class PasswordHasher {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyPassword(String password, String hash) {
    final hashedPassword = hashPassword(password);
    return hashedPassword == hash;
  }
}
