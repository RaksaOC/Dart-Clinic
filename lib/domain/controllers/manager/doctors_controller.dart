/// Doctors Controller (Manager)
library;

import '../../services/doctor_service.dart';
import '../../../domain/models/doctor.dart';

class DoctorsController {
  final DoctorService _doctorService;

  DoctorsController({DoctorService? doctorService})
    : _doctorService = doctorService ?? DoctorService();

  DoctorModel? createDoctor({
    required String doctorId,
    required String name,
    required String specialization,
    required String phoneNumber,
    required String email,
    required String address,
    required int age,
    required String gender,
    required String password,
  }) {
    return _doctorService.createDoctor(
      name: name,
      specialization: specialization,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      age: age,
      gender: gender,
      password: password,
    );
  }

  List<DoctorModel> getAllDoctors() => _doctorService.getAllDoctors();
  DoctorModel? getDoctorById(String id) => _doctorService.getDoctorById(id);
  List<DoctorModel> getDoctorsBySpecialization(String s) =>
      _doctorService.getDoctorsBySpecialization(s);
  List<DoctorModel> searchDoctorsByName(String name) =>
      _doctorService.searchDoctorsByName(name);
  bool updateDoctor(DoctorModel d) => _doctorService.updateDoctor(d);
  bool deleteDoctor(String id) => _doctorService.deleteDoctor(id);
}
