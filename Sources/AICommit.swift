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
    } else {
      print("Skipping...")
    }

    let diffs = getGitDiffs()
    print("Diffs collected, waiting for model response")

    var message: String
    var choice: Character = "r"
    repeat {
      message = await ai.generate(diffs: diffs)
      // commit message is streamed, so we don't print it again

      print("Press `y` to approve, `r` to regenerate or anything else to exit... ", terminator: "")
      choice = getChar()
      if choice == "r" {
        print("\nRegenerating...\n")
      } else if choice != "y" {
        print("\nExiting...")
        return
      }
    } while choice == "r"

    print("Committing...\n")
    _ = gitCommit(withMessage: message)

    print("🚀  Run `git push`?")
    print("Press `y` to approve, or anything else to exit... ", terminator: "")
    if !waitForChar(character: "y") { print("Exiting..."); return }
    print("Pushing...\n")
    gitPush()
  }
}
