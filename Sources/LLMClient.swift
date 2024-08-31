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
    var prompt = "Generate an appropriate git commit message using the following diffs, describing what the commit does. Be specific. Keep responses under 100 characters Only use one emoji in the commit message, at the beginning. Do not output other text other than the commit message. Do not return an empty commit message.\n\n```"
    prompt += diffs
    prompt += "\n```"
    let request = OKGenerateRequestData(model: modelName, prompt: prompt)

    var responseString = ""
    do {
      for try await response in ollama.generate(data: request) {
        responseString += response.response
      }
    } catch {
      print("\(error.localizedDescription)")
    }

    return responseString
  }
}
