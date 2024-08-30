//
//  File.swift
//  
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation

func getStagedFiles() -> [String] {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["git", "diff", "--name-only", "--cached"]
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        print("Failed to run git command: \(error)")
        return []
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    return output.split(separator: "\n").map { String($0) }
}
