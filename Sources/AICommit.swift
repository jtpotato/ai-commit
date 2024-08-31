// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation

@main
struct AICommit: AsyncParsableCommand {
  mutating func run() async throws {
    guard let ai = await LLMClient() else { print("Couldn't connect to Ollama"); return }
    
    print("⚙️  Stage any current files?")
    print("Press `y` to approve, or anything else to skip... ", terminator: "")
    if waitForChar(character: "y") {
      gitStage()
    }
    
    let diffs = getGitDiffs()
    print("Diffs collected, waiting for model response")
//    print(diffs)
    let message = await ai.generate(diffs: diffs)
    print("Generated commit message:")
    print(message)
    
    print("Press `y` to approve, or anything else to exit... ", terminator: "")
    if !waitForChar(character: "y") { return }
    print("Committing...\n")
    _ = gitCommit(withMessage: message)
    
    print("🚀  Run `git push`?")
    print("Press `y` to approve, or anything else to exit... ", terminator: "")
    if !waitForChar(character: "y") { return }
    print("Pushing...\n")
    gitPush()
  }
}
