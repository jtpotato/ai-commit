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
    2. Start with one appropriate emoji, in unicode.
    3. Use present tense (e.g., "Add", not "Added").
    4. Be specific but concise.
    5. Focus on the "what" and "why", not the "how".
    6. Mention affected components or files if relevant.
    7. Never output a blank message.
    8. Provide only the commit message, nothing else.
    9. Use markdown formatting like backticks for code.
    """

    if diffs.count > 120_000 {
      print("Diffs may be too long. Model may lose context.")
    }

    // my computer can't handle more than this
    let options = OKCompletionOptions(numCtx: 8_000, temperature: 0.7, numPredict: 64)

    let messages: [OKChatRequestData.Message] = [
        OKChatRequestData.Message(role: .system, content: systemPrompt),
        OKChatRequestData.Message(role: .user, content: diffs)
    ]

    var request = OKChatRequestData(model: modelName, messages: messages)
    request.options = options

    var responseString = ""
    do {
      for try await response in ollama.chat(data: request) {
        print(response.message?.content ?? "", terminator: "")
        responseString += response.message?.content ?? ""
      }
    } catch {
      print("\(error.localizedDescription)")
    }

    print("")

    return responseString
  }
}
