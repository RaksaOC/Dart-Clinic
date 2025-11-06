/// Manage Rooms UI
///
/// Provides CLI interface for room management operations.
library;

import 'package:prompts/prompts.dart' as prompts;
import '../../domain/models/room.dart';
import '../../domain/controllers/manager/rooms_controller.dart';
import 'package:dart_clinic/utils/formatter.dart';
import 'package:dart_clinic/utils/terminal.dart';

class ManageRooms {
  final RoomsController _manager;

  ManageRooms() : _manager = RoomsController();

  void display() {
    while (true) {
      TerminalUI.clearScreen();
      print('\n' + '=' * 50);
      print('MANAGE ROOMS');
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
          TerminalUI.pauseAndClear();
          break;
        case 'View All Rooms':
          _viewAllRooms();
          TerminalUI.pauseAndClear();
          break;
        case 'View Available Rooms':
          _viewAvailableRooms();
          TerminalUI.pauseAndClear();
          break;
        case 'View Occupied Rooms':
          _viewOccupiedRooms();
          TerminalUI.pauseAndClear();
          break;
        case 'Update Room':
          _updateRoom();
          TerminalUI.pauseAndClear();
          break;
        case 'Delete Room':
          _deleteRoom();
          TerminalUI.pauseAndClear();
          break;
        case 'View Room Occupancy Stats':
          _viewOccupancyStats();
          TerminalUI.pauseAndClear();
          break;
        case 'Back to Main Menu':
          return;
      }
    }
  }

  void _createRoom() {
    print('\nCREATE ROOM');
    print('-' * 50);

    try {
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
        roomNumber: roomNumber.trim(),
        roomType: roomType,
        dailyRate: dailyRate,
        notes: notes.trim().isEmpty ? null : notes.trim(),
      );

      if (room != null) {
        print('\nRoom created successfully.');
        print('Room ID: ${room.id}');
        print('Room Number: ${room.roomNumber}');
        print('Type: ${room.roomType}');
        print('Daily Rate: \$${room.dailyRate.toStringAsFixed(2)}');
      } else {
        print('\nFailed to create room. Room ID might already exist.');
      }
    } catch (e) {
      print('\nError: ${e.toString()}');
    }
  }

  void _viewAllRooms() {
    print('\nALL ROOMS');
    print('-' * 50);
    final rooms = _manager.getAllRooms();
    if (rooms.isEmpty) {
      print('\nNo rooms found.');
      return;
    }
    final options = formatCardOptions(rooms);
    for (final line in options) {
      print(line);
    }
  }

  void _viewAvailableRooms() {
    print('\nAVAILABLE ROOMS');
    print('-' * 50);
    final rooms = _manager.getAvailableRooms();
    if (rooms.isEmpty) {
      print('\nNo available rooms.');
      return;
    }
    final options = formatCardOptions(rooms);
    for (final line in options) {
      print(line);
    }
  }

  void _viewOccupiedRooms() {
    print('\nOCCUPIED ROOMS');
    print('-' * 50);
    final rooms = _manager.getOccupiedRooms();
    if (rooms.isEmpty) {
      print('\nNo occupied rooms.');
      return;
    }
    final options = formatCardOptions(rooms);
    for (final line in options) {
      print(line);
    }
  }

  void _updateRoom() {
    print('\nUPDATE ROOM');
    print('-' * 50);
    final rooms = _manager.getAllRooms();
    if (rooms.isEmpty) {
      print('\nNo rooms found.');
      return;
    }

    final options = formatCardOptions(rooms);
    final chosen = prompts.choose('Select a room to update:', options);
    final idx = options.indexOf(chosen!);
    final room = rooms[idx];

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
      print('\nRoom updated successfully.');
    } else {
      print('\nFailed to update room.');
    }
  }

  void _deleteRoom() {
    print('\nDELETE ROOM');
    print('-' * 50);
    final rooms = _manager.getAllRooms();
    if (rooms.isEmpty) {
      print('\nNo rooms found.');
      return;
    }

    final options = formatCardOptions(rooms);
    final chosen = prompts.choose('Select a room to delete:', options);
    final idx = options.indexOf(chosen!);
    final room = rooms[idx];

    if (room.isOccupied) {
      print('\nCannot delete room. Room is currently occupied.');
      return;
    }

    final confirm = prompts.getBool(
      'Are you sure you want to delete this room? (y/n)',
    );
    if (confirm) {
      if (_manager.deleteRoom(room.id)) {
        print('\nRoom deleted successfully.');
      } else {
        print('\nFailed to delete room.');
      }
    }
  }

  void _viewOccupancyStats() {
    print('\nROOM OCCUPANCY STATISTICS');
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
