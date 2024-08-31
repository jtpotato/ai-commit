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

/// Blocks thread and waits for specific character to appear.
/// Returns `true` if character is found.
/// Returns `false` if character is not found.
func waitForChar(character: String) -> Bool {
//    flushStandardInput()

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

  print("Press '\(character)' to approve, otherwise exit... ", terminator: "")
  let res = getchar()
  if res == Int32(character.utf8.first!) { // Compare with the ASCII value of the character
    return true
  } else {
    print("Exiting...")
    return false
  }
}
