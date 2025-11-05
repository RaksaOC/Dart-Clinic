/// Person domain model
///
/// Base model representing a person with personal information.
library;

class PersonModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phoneNumber;
  final String email;
  final String address;

  PersonModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });
}
