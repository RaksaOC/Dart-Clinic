/// Manager Repository
///
/// Responsible for data persistence operations for managers.
/// Handles CRUD operations for manager entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/models/manager.dart';

class ManagerRepository extends RepositoryBase<ManagerModel> {
  ManagerRepository() : super('db/managers.json');

  @override
  Map<String, dynamic> toJson(ManagerModel entity) {
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
  ManagerModel fromJson(Map<String, dynamic> json) {
    return ManagerModel(
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
