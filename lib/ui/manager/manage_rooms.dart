/// Manage Rooms UI
///
/// Provides CLI interface for room management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/room.dart';
import '../../domain/usecases/manager.dart';

class ManageRooms {
  final Manager _manager;

  ManageRooms() : _manager = Manager();

  void display() {
    while (true) {
      print('\n' + '=' * 50);
      print('🏥 MANAGE ROOMS');
      print('=' * 50);

      final choice = prompts.choose('\nWhat would you like to do?', [
        'Create Room',
        'View All Rooms',
        'View Available Rooms',
        'View Occupied Rooms',
        'Update Room',
        'Delete Room',
        'View Room Occupancy Stats',
        'Back to Main Menu',
      ]);

      switch (choice) {
        case 'Create Room':
          _createRoom();
          break;
        case 'View All Rooms':
          _viewAllRooms();
          break;
        case 'View Available Rooms':
          _viewAvailableRooms();
          break;
        case 'View Occupied Rooms':
          _viewOccupiedRooms();
          break;
        case 'Update Room':
          _updateRoom();
          break;
        case 'Delete Room':
          _deleteRoom();
          break;
        case 'View Room Occupancy Stats':
          _viewOccupancyStats();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createRoom() {
    print('\n🏥 CREATE ROOM');
    print('-' * 50);

    try {
      final roomId = prompts.get('Room ID (e.g., R001):');
      final roomNumber = prompts.get('Room Number:');
      final roomType =
          prompts.choose('Room Type:', [
            'general',
            'private',
            'ICU',
            'emergency',
          ]) ??
          'general';
      final dailyRate = double.parse(prompts.get('Daily Rate:'));
      final notes = prompts.get('Notes (optional, press Enter to skip):');

      final room = _manager.createRoom(
        roomId: roomId.trim(),
        roomNumber: roomNumber.trim(),
        roomType: roomType,
        dailyRate: dailyRate,
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (room != null) {
        print('\n✅ Room created successfully!');
        print('Room ID: ${room.id}');
        print('Room Number: ${room.roomNumber}');
        print('Type: ${room.roomType}');
        print('Daily Rate: \$${room.dailyRate.toStringAsFixed(2)}');
      } else {
        print('\n❌ Failed to create room. Room ID might already exist.');
      }
    } catch (e) {
      print('\n❌ Error: ${e.toString()}');
    }
  }

  void _viewAllRooms() {
    print('\n🏥 ALL ROOMS');
    print('-' * 50);
    final rooms = _manager.getAllRooms();
    if (rooms.isEmpty) {
      print('\nNo rooms found.');
      return;
    }
    _displayRooms(rooms);
  }

  void _viewAvailableRooms() {
    print('\n✅ AVAILABLE ROOMS');
    print('-' * 50);
    final rooms = _manager.getAvailableRooms();
    if (rooms.isEmpty) {
      print('\nNo available rooms.');
      return;
    }
    _displayRooms(rooms);
  }

  void _viewOccupiedRooms() {
    print('\n🔴 OCCUPIED ROOMS');
    print('-' * 50);
    final rooms = _manager.getOccupiedRooms();
    if (rooms.isEmpty) {
      print('\nNo occupied rooms.');
      return;
    }
    _displayRooms(rooms);
  }

  void _displayRooms(List<RoomModel> rooms) {
    print(
      '\n${'ID'.padRight(8)} ${'Room #'.padRight(10)} ${'Type'.padRight(12)} ${'Rate'.padRight(10)} ${'Status'.padRight(12)} ${'Patient ID'.padRight(12)}',
    );
    print('-' * 80);
    for (final room in rooms) {
      final status = room.isOccupied ? '🔴 Occupied' : '✅ Available';
      final patientId = room.patientId ?? 'N/A';
      print(
        '${room.id.padRight(8)} ${room.roomNumber.padRight(10)} ${room.roomType.padRight(12)} \$${room.dailyRate.toStringAsFixed(2).padLeft(8)} ${status.padRight(12)} ${patientId.padRight(12)}',
      );
    }
  }

  void _updateRoom() {
    print('\n✏️  UPDATE ROOM');
    print('-' * 50);
    final roomId = prompts.get('Enter Room ID to update:');
    final room = _manager.getRoomById(roomId.trim());

    if (room == null) {
      print('\n❌ Room not found.');
      return;
    }

    print('\nCurrent Room Details:');
    print('Room Number: ${room.roomNumber}');
    print('Type: ${room.roomType}');
    print('Daily Rate: \$${room.dailyRate}');
    print('Status: ${room.isOccupied ? "Occupied" : "Available"}');
    print('Notes: ${room.notes ?? "None"}');

    final newRoomNumber = prompts.get(
      'New Room Number (or press Enter to keep):',
    );
    final newType =
        prompts.choose('New Room Type (or press Enter to skip):', [
          'general',
          'private',
          'ICU',
          'emergency',
          'Skip',
        ]) ??
        'Skip';
    final newRateStr = prompts.get('New Daily Rate (or press Enter to keep):');
    final newNotes = prompts.get('New Notes (or press Enter to keep):');

    final updatedRoom = RoomModel(
      id: room.id,
      roomNumber: newRoomNumber.trim().isEmpty
          ? room.roomNumber
          : newRoomNumber.trim(),
      roomType: newType == 'Skip' ? room.roomType : newType,
      dailyRate: newRateStr.trim().isEmpty
          ? room.dailyRate
          : double.parse(newRateStr),
      isOccupied: room.isOccupied,
      patientId: room.patientId,
      notes: newNotes.trim().isEmpty ? room.notes : newNotes.trim(),
    );

    if (_manager.updateRoom(updatedRoom)) {
      print('\n✅ Room updated successfully!');
    } else {
      print('\n❌ Failed to update room.');
    }
  }

  void _deleteRoom() {
    print('\n🗑️  DELETE ROOM');
    print('-' * 50);
    final roomId = prompts.get('Enter Room ID to delete:');
    final room = _manager.getRoomById(roomId.trim());

    if (room == null) {
      print('\n❌ Room not found.');
      return;
    }

    if (room.isOccupied) {
      print('\n❌ Cannot delete room. Room is currently occupied.');
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to delete this room? (y/n)',
    );
    if (confirm) {
      if (_manager.deleteRoom(roomId.trim())) {
        print('\n✅ Room deleted successfully!');
      } else {
        print('\n❌ Failed to delete room.');
      }
    }
  }

  void _viewOccupancyStats() {
    print('\n📊 ROOM OCCUPANCY STATISTICS');
    print('-' * 50);
    final stats = _manager.getOccupancyStats();
    print('\nTotal Rooms: ${stats['totalRooms']}');
    print('Occupied Rooms: ${stats['occupiedRooms']}');
    print('Available Rooms: ${stats['availableRooms']}');
    print(
      'Overall Occupancy: ${(stats['overallOccupancy'] as double).toStringAsFixed(2)}%',
    );
  }
}
