//
//  File.swift
//  
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation

/// Blocks thread and waits for specific character to appear.
/// Returns `true` if character is found.
/// Returns `false` if character is not found.
func waitForChar(character: String) -> Bool {
  let char = Character(character)
  let res = getchar()
  if res == Int32(char.asciiValue!) {
    return true
  }
  
  return false
}
