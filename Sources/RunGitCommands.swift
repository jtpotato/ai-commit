//
//  RunGitCommands.swift
//
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation

/// Runs a specified git command with optional arguments and returns output or error messages.
func runGitCommand(arguments: [String]) -> (output: String, error: String, success: Bool) {
    let process = Process()
    let outputPipe = Pipe()
    let errorPipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
    process.arguments = arguments
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    do {
        try process.run()
        process.waitUntilExit()

        // Capture output and error data
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        let output = String(data: outputData, encoding: .utf8) ?? ""
        let errorOutput = String(data: errorData, encoding: .utf8) ?? ""

        return (output: output, error: errorOutput, success: process.terminationStatus == 0)
    } catch {
        return (output: "", error: "Error: \(error.localizedDescription)", success: false)
    }
}

/// Runs `git commit -m <message>`
func gitCommit(withMessage message: String) -> Bool {
    let result = runGitCommand(arguments: ["commit", "-m", message])
    if result.success {
        print("Commit successful. \(result.output)")
    } else {
        print("Commit failed. \(result.error)")
    }
    return result.success
}

/// Runs `git push`
func gitPush() {
    let result = runGitCommand(arguments: ["push"])
    if result.success {
        print("Push successful. \(result.output)")
    } else {
        print("Push failed. \(result.error)")
    }
}

/// Runs `git add .`
func gitStage() {
    let result = runGitCommand(arguments: ["add", "."])
    if result.success {
        print("All changes staged successfully.")
    } else {
        print("Staging failed. \(result.error)")
    }
}
