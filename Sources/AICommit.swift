// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser

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
  }
}
