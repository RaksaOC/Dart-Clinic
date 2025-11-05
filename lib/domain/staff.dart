import 'package:dart_clinic/domain/person.dart';

class Staff extends Person {
  final String password;

  Staff({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required super.address,
    required this.password,
  });
}
