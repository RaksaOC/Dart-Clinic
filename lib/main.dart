/// Hospital Management System - Main Entry Point
///
/// This is the entry point for the Hospital Management CLI application.
/// It initializes the UI and starts the main menu.
library;

import 'ui/main_menu.dart';
import 'ui/doctor_menu.dart';
import 'ui/manager_menu.dart';

// Data layer - Repositories
import 'data/room_repo.dart';
import 'data/doctor_repo.dart';
import 'data/patient_repo.dart';
import 'data/admission_repo.dart';
import 'data/manager_repo.dart';
import 'data/appointment_repo.dart';
import 'data/prescription_repo.dart';

// Service layer
import 'service/room_service.dart';
import 'service/doctor_service.dart';
import 'service/patient_service.dart';
import 'service/admission_service.dart';
import 'service/manager_service.dart';
import 'service/appointment_service.dart';
import 'service/prescription_service.dart';

// Domain layer - Usecases
import 'domain/usecases/manager.dart' as manager_usecase;
import 'domain/usecases/doctor.dart' as doctor_usecase;

void main() {
  // Initialize repositories
  final roomRepository = RoomRepository();
  final doctorRepository = DoctorRepository();
  final patientRepository = PatientRepository();
  final admissionRepository = AdmissionRepository();
  final managerRepository = ManagerRepository();
  final appointmentRepository = AppointmentRepository();
  final prescriptionRepository = PrescriptionRepository();

  // Initialize repositories
  roomRepository.initialize();
  doctorRepository.initialize();
  patientRepository.initialize();
  admissionRepository.initialize();
  managerRepository.initialize();
  appointmentRepository.initialize();
  prescriptionRepository.initialize();

  // Initialize services
  final roomService = RoomService(roomRepository);
  final doctorService = DoctorService(doctorRepository);
  final patientService = PatientService(patientRepository);
  final admissionService = AdmissionService(
    admissionRepository,
    roomRepository,
  );
  final managerService = ManagerService(managerRepository);
  final appointmentService = AppointmentService(appointmentRepository);
  final prescriptionService = PrescriptionService(prescriptionRepository);

  // Initialize usecases
  final managerUsecase = manager_usecase.Manager(
    roomService: roomService,
    doctorService: doctorService,
    patientService: patientService,
    admissionService: admissionService,
    managerService: managerService,
    roomRepository: roomRepository,
    admissionRepository: admissionRepository,
  );

  // Note: Doctor usecase will be created after login with the authenticated doctor
  // Initialize UI components
  final doctorMenu = DoctorMenu();
  final managerMenu = ManagerMenu(manager: managerUsecase);
  final mainMenu = MainMenu(doctorMenu: doctorMenu, managerMenu: managerMenu);

  // Start the application
  mainMenu.display();
}
