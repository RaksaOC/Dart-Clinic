library;

import 'dart:io';

class TerminalUI {
  static void clearScreen() {
    // ANSI: clear screen and move cursor to 0,0
    stdout.write('\x1B[2J\x1B[H');
  }

  static void waitForEnter([String message = 'Press Enter to continue...']) {
    stdout.write('\n$message');
    stdin.readLineSync();
  }

  static void pauseAndClear() {
    waitForEnter();
    clearScreen();
  }
}
