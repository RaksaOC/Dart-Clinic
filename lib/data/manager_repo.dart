/// Manager Repository
///
/// Responsible for data persistence operations for managers.
/// Handles CRUD operations for manager entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/manager.dart';

class ManagerRepository extends RepositoryBase<Manager> {
  ManagerRepository() : super('lib/db/managers.json');

  @override
  Map<String, dynamic> toJson(Manager entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'email': entity.email,
      'age': entity.age,
      'gender': entity.gender,
      'phoneNumber': entity.phoneNumber,
      'address': entity.address,
      'password': entity.password,
    };
  }

  @override
  Manager fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      password: json['password'] as String,
    );
  }
}
