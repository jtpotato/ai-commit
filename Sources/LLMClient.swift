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

  func generate(diffs: String) async -> String {
//    print(diffs.count)
    let prompt = "You will be given a git diff. Write a concise git commit message. Output *only* this commit message. Git commit messages are less than 20 words. Never output a blank message. Always include an emoji in the front of the message.\n\n"

    let options = OKCompletionOptions(numCtx: 32_000, numPredict: 64)

    print(prompt + diffs)

    var request = OKGenerateRequestData(model: modelName, prompt: prompt + diffs)
    request.options = options

    var responseString = ""
    do {
      for try await response in ollama.generate(data: request) {
        print(response.response, terminator: "")
        responseString += response.response
      }
    } catch {
      print("\(error.localizedDescription)")
    }

    return responseString
  }
}
