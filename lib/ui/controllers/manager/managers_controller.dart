/// Managers Controller (Manager)
library;

import '../../../domain/services/manager_service.dart';
import '../../../domain/models/manager.dart';

class ManagersController {
  final ManagerService _managerService;

  ManagersController({ManagerService? managerService})
    : _managerService = managerService ?? ManagerService();

  ManagerModel? createManager({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    required String phoneNumber,
    required String address,
  }) => _managerService.createManager(
    name: name,
    email: email,
    password: password,
    age: age,
    gender: gender,
    phoneNumber: phoneNumber,
    address: address,
  );

  List<ManagerModel> getAllManagers() => _managerService.getAllManagers();
  ManagerModel? getManagerById(String id) => _managerService.getManagerById(id);
  bool updateManager(ManagerModel m) => _managerService.updateManager(m);
  bool deleteManager(String id) => _managerService.deleteManager(id);
}
