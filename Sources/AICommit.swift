// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation

@main
struct AICommit: AsyncParsableCommand {
  mutating func run() async throws {
    guard let ai = await LLMClient() else { print("Couldn't connect to Ollama"); return }
    let diffs = getGitDiffs()
    print("Diffs collected, waiting for model response")
//    print(diffs)
    let message = await ai.generate(diffs: diffs)
    print("Generated commit message:")
    print(message)
    print("[y] to approve, any other key to dismiss.")
    
    var res = waitForChar(character: "y")
    if !res { return }
    print("Committing...\n")
    _ = gitCommit(withMessage: message)
    
    print("Run `git push`? [y] to approve, any other key to dismiss.")
    res = waitForChar(character: "y")
    if !res { return }
    print("Pushing...\n")
    gitPush()
  }
}
