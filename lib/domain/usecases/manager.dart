/// Manager Usecase
///
/// Orchestrates manager operations. Acts as the public API for manager functionality.
/// UI layer interacts with this class, which delegates to services.
library;

import '../models/manager.dart';
import '../models/room.dart';
import '../models/doctor.dart';
import '../models/patient.dart';
import '../models/admission.dart';
import '../models/status.dart';
import '../../service/room_service.dart';
import '../../service/doctor_service.dart';
import '../../service/patient_service.dart';
import '../../service/admission_service.dart';
import '../../service/manager_service.dart';
import '../../data/room_repo.dart';
import '../../data/admission_repo.dart';

class Manager {
  final ManagerModel? _currentManager;
  final RoomService _roomService;
  final DoctorService _doctorService;
  final PatientService _patientService;
  final AdmissionService _admissionService;
  final ManagerService _managerService;
  final RoomRepository _roomRepository;
  final AdmissionRepository _admissionRepository;

  Manager({
    ManagerModel? currentManager,
    required RoomService roomService,
    required DoctorService doctorService,
    required PatientService patientService,
    required AdmissionService admissionService,
    required ManagerService managerService,
    required RoomRepository roomRepository,
    required AdmissionRepository admissionRepository,
  }) : _currentManager = currentManager,
       _roomService = roomService,
       _doctorService = doctorService,
       _patientService = patientService,
       _admissionService = admissionService,
       _managerService = managerService,
       _roomRepository = roomRepository,
       _admissionRepository = admissionRepository;

  /// Get current manager model
  ManagerModel? get currentManager => _currentManager;

  // ========== Manager Authentication & Management ==========

  /// Authenticate manager
  ManagerModel? authenticateManager(String email, String password) {
    return _managerService.authenticateManager(email, password);
  }

  /// Find manager by email
  ManagerModel? findManagerByEmail(String email) {
    return _managerService.findManagerByEmail(email);
  }

  /// Get all managers
  List<ManagerModel> getAllManagers() {
    return _managerService.getAllManagers();
  }

  /// Get manager by ID
  ManagerModel? getManagerById(String managerId) {
    return _managerService.getManagerById(managerId);
  }

  /// Create a new manager
  ManagerModel? createManager({
    required String managerId,
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    required String phoneNumber,
    required String address,
  }) {
    return _managerService.createManager(
      managerId: managerId,
      name: name,
      email: email,
      password: password,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  /// Update manager information
  bool updateManager(ManagerModel manager) {
    return _managerService.updateManager(manager);
  }

  /// Delete a manager
  bool deleteManager(String managerId) {
    return _managerService.deleteManager(managerId);
  }

  // ========== Room Management ==========

  /// Create a new room
  RoomModel? createRoom({
    required String roomId,
    required String roomNumber,
    required String roomType,
    required double dailyRate,
    String? notes,
  }) {
    return _roomService.createRoom(
      roomId: roomId,
      roomNumber: roomNumber,
      roomType: roomType,
      dailyRate: dailyRate,
      notes: notes,
    );
  }

  /// Get room by ID
  RoomModel? getRoomById(String roomId) {
    return _roomService.getRoomById(roomId);
  }

  /// Get all rooms
  List<RoomModel> getAllRooms() {
    return _roomService.getAllRooms();
  }

  /// Get available rooms
  List<RoomModel> getAvailableRooms() {
    return _roomService.getAvailableRooms();
  }

  /// Get occupied rooms
  List<RoomModel> getOccupiedRooms() {
    final rooms = _roomService.getAllRooms();
    return rooms.where((room) => room.isOccupied).toList();
  }

  /// Get rooms by type
  List<RoomModel> getRoomsByType(String roomType) {
    return _roomService.getRoomsByType(roomType);
  }

  /// Update room information
  bool updateRoom(RoomModel room) {
    return _roomRepository.update(room);
  }

  /// Delete a room
  bool deleteRoom(String roomId) {
    // Check if room is occupied
    final room = _roomService.getRoomById(roomId);
    if (room != null && room.isOccupied) {
      return false; // Cannot delete occupied room
    }
    return _roomRepository.delete(roomId);
  }

  /// Get occupancy statistics
  Map<String, dynamic> getOccupancyStats() {
    return _roomService.getOccupancyStats();
  }

  /// Get rooms by patient ID (currently occupied)
  RoomModel? getRoomByPatientId(String patientId) {
    final rooms = _roomService.getAllRooms();
    try {
      return rooms.firstWhere(
        (room) => room.patientId == patientId && room.isOccupied,
      );
    } catch (e) {
      return null;
    }
  }

  // ========== Doctor Management ==========

  /// Create a new doctor
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
      doctorId: doctorId,
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

  /// Get all doctors
  List<DoctorModel> getAllDoctors() {
    return _doctorService.getAllDoctors();
  }

  /// Get doctor by ID
  DoctorModel? getDoctorById(String doctorId) {
    return _doctorService.getDoctorById(doctorId);
  }

  /// Get doctors by specialization
  List<DoctorModel> getDoctorsBySpecialization(String specialization) {
    return _doctorService.getDoctorsBySpecialization(specialization);
  }

  /// Search doctors by name
  List<DoctorModel> searchDoctorsByName(String name) {
    return _doctorService.searchDoctorsByName(name);
  }

  /// Update doctor information
  bool updateDoctor(DoctorModel doctor) {
    return _doctorService.updateDoctor(doctor);
  }

  /// Delete a doctor
  bool deleteDoctor(String doctorId) {
    return _doctorService.deleteDoctor(doctorId);
  }

  // ========== Patient Management ==========

  /// Create a new patient
  PatientModel? createPatient({
    required String patientId,
    required String name,
    required int age,
    required String gender,
    required String phoneNumber,
    required String email,
    required String address,
  }) {
    return _patientService.createPatient(
      patientId: patientId,
      name: name,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
    );
  }

  /// Get all patients
  List<PatientModel> getAllPatients() {
    return _patientService.getAllPatients();
  }

  /// Get patient by ID
  PatientModel? getPatientById(String patientId) {
    return _patientService.getPatientById(patientId);
  }

  /// Search patients by name
  List<PatientModel> searchPatientsByName(String name) {
    return _patientService.searchPatientsByName(name);
  }

  /// Get patients by gender
  List<PatientModel> getPatientsByGender(String gender) {
    return _patientService.getPatientsByGender(gender);
  }

  /// Get admitted patients
  List<PatientModel> getAdmittedPatients() {
    final activeAdmissions = _admissionService.getActiveAdmissions();
    final admittedPatients = <PatientModel>[];
    for (final admission in activeAdmissions) {
      final patient = _patientService.getPatientById(admission.patientId);
      if (patient != null) {
        admittedPatients.add(patient);
      }
    }
    return admittedPatients;
  }

  /// Update patient information
  bool updatePatient(PatientModel patient) {
    return _patientService.updatePatient(patient);
  }

  /// Delete a patient
  bool deletePatient(String patientId) {
    // Check if patient is currently admitted
    final activeAdmission = _admissionService.getActiveByPatientId(patientId);
    if (activeAdmission != null) {
      return false; // Cannot delete admitted patient
    }
    return _patientService.deletePatient(patientId);
  }

  // ========== Admission Management ==========

  /// Get admission by ID
  AdmissionModel? getAdmissionById(String admissionId) {
    return _admissionRepository.getById(admissionId);
  }

  /// Get all admissions
  List<AdmissionModel> getAllAdmissions() {
    return _admissionService.getAllAdmissions();
  }

  /// Admit a patient to a room
  AdmissionModel? admitPatient({
    required String admissionId,
    required String patientId,
    required String roomId,
    String? notes,
  }) {
    // Validation: check patient exists
    final patient = _patientService.getPatientById(patientId);
    if (patient == null) {
      return null; // Patient not found
    }

    // Delegate to admission service
    return _admissionService.admitPatient(
      admissionId: admissionId,
      patientId: patientId,
      roomId: roomId,
      notes: notes,
    );
  }

  /// Discharge a patient
  bool dischargePatient(String admissionId) {
    return _admissionService.dischargePatient(admissionId);
  }

  /// Get admissions by patient ID
  List<AdmissionModel> getAdmissionsByPatientId(String patientId) {
    return _admissionService.getAdmissionsByPatientId(patientId);
  }

  /// Get admissions by room ID
  List<AdmissionModel> getAdmissionsByRoomId(String roomId) {
    return _admissionService.getAdmissionsByRoomId(roomId);
  }

  /// Get active admissions
  List<AdmissionModel> getActiveAdmissions() {
    return _admissionService.getActiveAdmissions();
  }

  /// Get active admission for a patient
  AdmissionModel? getActiveAdmissionByPatientId(String patientId) {
    return _admissionService.getActiveByPatientId(patientId);
  }

  /// Get discharged admissions
  List<AdmissionModel> getDischargedAdmissions() {
    final allAdmissions = _admissionService.getAllAdmissions();
    return allAdmissions
        .where((a) => a.status == AdmissionStatus.discharged)
        .toList();
  }
}
