// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser

@main
struct AICommit: AsyncParsableCommand {
  mutating func run() throws {
    let staged = getStagedFiles()
    print(staged)
  }
}
