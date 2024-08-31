// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation

@main
struct AICommit: AsyncParsableCommand {
  mutating func run() async throws {
    guard let ai = await LLMClient() else { print("Couldn't connect to ollama"); return }
    let diffs = getGitDiffs()
    print("Diffs collected, waiting for model response")
//    print(diffs)
    let message = await ai.generate(diffs: diffs)
    print("Generated commit message:")
    print(message)
    print("[y] to approve, any other key to dismiss.")
    
    let res = waitForChar(character: "y")
    if !res { return }
    print("Commiting...")
    _ = gitCommit(withMessage: message)
  }
}
