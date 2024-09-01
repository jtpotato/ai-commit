//
//  File.swift
//
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation

// Flush standard input
func flushStandardInput() {
  let input = FileHandle.standardInput
  input.readData(ofLength: 1024) // Read a fixed number of bytes to clear the buffer
}

/// Blocks thread and waits for any character input.
/// Returns the character that was input.
func getChar() -> Character {
  // Save the current terminal settings
  var oldt = termios()
  tcgetattr(STDIN_FILENO, &oldt)

  var newt = oldt
  newt.c_lflag &= ~UInt(ICANON | ECHO) // Disable canonical mode and echo
  tcsetattr(STDIN_FILENO, TCSANOW, &newt) // Apply the new settings

  defer {
    // Restore old terminal settings on exit
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt)
  }

  let res = getchar()
  return Character(UnicodeScalar(UInt32(res))!)
}


/// Blocks thread and waits for specific character to appear.
/// Returns `true` if character is found.
/// Returns `false` if character is not found.
/// Blocks thread and waits for specific character to appear.
/// Returns `true` if character is found.
/// Returns `false` if character is not found.
func waitForChar(character: Character) -> Bool {
    let inputChar = getChar()
    return inputChar == character
}
