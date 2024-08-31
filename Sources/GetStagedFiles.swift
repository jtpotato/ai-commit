//
//  File.swift
//
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation

import Foundation

func getGitDiffs() -> String {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
  process.arguments = ["git", "diff", "--cached"]

  let pipe = Pipe()
  process.standardOutput = pipe
  process.standardError = pipe

  var outputString = ""

  do {
    try process.run()
    let fileHandle = pipe.fileHandleForReading

    // Read output line by line
    while true {
      let data = fileHandle.readData(ofLength: 4096)
      if data.count == 0 {
        break
      }
      if let outputPart = String(data: data, encoding: .utf8) {
        outputString += outputPart
      }
    }

    process.waitUntilExit()
  } catch {
    print("Failed to run git command: \(error)")
    return ""
  }
  
  // Filter out large diffs
  let filteredDiffs = outputString.split(separator: "\n").filter { line in
      // Check if the line indicates a file change
      
      let fileSize = line.count // This is just a placeholder
      return fileSize <= 1_000
  }
  
  return filteredDiffs.joined(separator: "\n")
}
