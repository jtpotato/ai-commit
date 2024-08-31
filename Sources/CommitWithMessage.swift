//
//  File.swift
//
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation

func gitCommit(withMessage message: String) -> Bool {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
  process.arguments = ["git", "commit", "-m", message]

  // Redirecting the output and error to pipes
  let outputPipe = Pipe()
  let errorPipe = Pipe()
  process.standardOutput = outputPipe
  process.standardError = errorPipe

  do {
    try process.run()
    process.waitUntilExit()

    // Capture the output
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: outputData, encoding: .utf8) ?? ""
    let errorOutput = String(data: errorData, encoding: .utf8) ?? ""

    if process.terminationStatus == 0 {
      print("Commit successful: \(output)")
      return true
    } else {
      print("Commit failed: \(errorOutput)")
      return false
    }
  } catch {
    print("Failed to run git commit: \(error.localizedDescription)")
    return false
  }
}

func gitPush() {
  let process = Process()
  let outputPipe = Pipe()
  let errorPipe = Pipe()

  process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
  process.arguments = ["push"]
  process.standardOutput = outputPipe
  process.standardError = errorPipe

  do {
    try process.run()

    // Capture output
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    let output = String(data: outputData, encoding: .utf8) ?? "No output"
    let errorOutput = String(data: errorData, encoding: .utf8) ?? "No error output"

    print("Output: \(output)")
    if !errorOutput.isEmpty {
      print("Error: \(errorOutput)")
    }
  } catch {
    print("Error running git push: \(error.localizedDescription)")
  }
}
