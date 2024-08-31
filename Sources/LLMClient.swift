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
    let systemPrompt = """
    You are a Git commit message generator. Your task is to create concise, informative commit messages based on git diffs. Follow these rules:
    1. Summarize the main changes in 5-10 words.
    2. Start with an appropriate emoji.
    3. Use present tense (e.g., "Add", not "Added").
    4. Be specific but concise.
    5. Focus on the "what" and "why", not the "how".
    6. Mention affected components or files if relevant.
    7. Never output a blank message.
    8. Provide only the commit message, nothing else.
    """

    let options = OKCompletionOptions(numCtx: 128_000, temperature: 0.5, numPredict: 64)

    var request = OKGenerateRequestData(model: modelName, prompt: diffs)
    request.options = options
    request.system = systemPrompt

    var responseString = ""
    do {
      for try await response in ollama.generate(data: request) {
        print(response.response, terminator: "")
        responseString += response.response
      }
    } catch {
      print("\(error.localizedDescription)")
    }

    print("")

    return responseString
  }
}
