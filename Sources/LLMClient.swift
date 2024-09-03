//
//  File.swift
//
//
//  Created by Joel Tan on 31/8/2024.
//

import Foundation
import OllamaKit

struct LLMClient {
  let ollama: OllamaKit
  let modelName: String

  init?() async {
    ollama = OllamaKit()
    do {
      let models = try await ollama.models().models
      guard let model = models.first else { return nil }
      modelName = model.name
    } catch {
      print("\(error.localizedDescription)")
      return nil
    }
  }

  func chunkDiff(_ diff: String, maxChunkSize: Int = 10000) -> [String] {
      var chunks: [String] = []
      let lines = diff.split(separator: "\n")
      var currentChunk = ""

      for line in lines {
          if currentChunk.count + line.count > maxChunkSize {
              chunks.append(currentChunk)
              currentChunk = ""
          }
          currentChunk += line + "\n"
      }

      if !currentChunk.isEmpty {
          chunks.append(currentChunk)
      }

      return chunks
  }

  func summarizeChunks(_ chunks: [String]) async -> [String] {
      await withTaskGroup(of: String.self) { group in
          for chunk in chunks {
              group.addTask {
                  do {
                      let prompt = "Summarize the following code changes into one sentence:\n\(chunk)"
                      let data = OKGenerateRequestData(model: modelName, prompt: prompt)
                      var responseString = ""
                      for try await response in ollama.generate(data: data) {
                          responseString += response.response
                      }

                      let formattedString = responseString.trimmingCharacters(in: .whitespaces)
                      print("Summary: ", formattedString)
                      return formattedString
                  } catch {
                      print("Error summarizing chunk: \(error.localizedDescription)")
                      return "Error summarizing chunk"
                  }
              }
          }

          var summaries: [String] = []
          for await summary in group {
              summaries.append(summary)
          }
          return summaries
      }
  }

  func generateFinalCommitMessage(_ summary: String) async -> String {
      // Use the LLM to create the final commit message based on the combined summaries
      do {
          let prompt = """
          Based on the following summary of code changes, generate a concise and informative commit message.
          Remember:
          Commit messages must start with an emoji.
          Commit messages must be less than 72 characters.

          Changes made:
          \(summary)
          """
          let data = OKGenerateRequestData(model: modelName, prompt: prompt)
          var commitMessage = ""
          for try await response in ollama.generate(data: data) {
              commitMessage += response.response
          }
          return commitMessage.trimmingCharacters(in: .whitespacesAndNewlines)
      } catch {
          print("Error generating final commit message: \(error.localizedDescription)")
          return "Error generating commit message"
      }
  }

  func generate(diffs: String) async -> String {
      print("Chunking changes...")
      let chunks = chunkDiff(diffs, maxChunkSize: 32000)
      print("Summarizing chunks...")
      let summaries = await summarizeChunks(chunks)
      let combinedSummary = summaries.joined(separator: "\n")
      let message = await generateFinalCommitMessage(combinedSummary)
      print("Commit message:")
      print(message)

      // Now use the LLM to generate a final commit message based on these summaries
      return message
  }
}
