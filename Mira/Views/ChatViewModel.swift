//
//  MessagesViewModel.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import Foundation
import Observation
import SwiftUI

@Observable @MainActor
final class ChatViewModel {
  public var messages: [Message] = []
  public var onlineStatus: OnlineStatus = .offline
  public var showDisplayTypingIndicator: Bool = false

  private let llmService: LLMService = .init()
  private var task: Task<Void, Never>?

  private var onlineTransitionTask: Task<Void, Never>?
  private var inactivityTask: Task<Void, Never>?
  private var offlineTransitionTask: Task<Void, Never>?
  private var lastAIActivityAt: Date?

  init() {}

  public func submitMessage(text: String) {
    task?.cancel()
    task = Task {
      let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmedText.isEmpty else { return }

      let newUserMessage = Message(isUser: true, content: trimmedText)
      messages.append(newUserMessage)

      await awaitOnlineTransitionIfNeeded()
      showDisplayTypingIndicator = true

      do {
        let responses = try await llmService.responses(for: messages)
        for response in responses {
          try Task.checkCancellation()
          switch response {
          case let .message(string):
            showDisplayTypingIndicator = false
            let newMessage = Message(isUser: false, content: string, reaction: nil)
            messages.append(newMessage)
            noteAIActivity()

            guard response != responses.last else { break }

            showDisplayTypingIndicator = true
            try await Task.sleep(for: .seconds(typingDelaySeconds(for: newMessage.content)))
          case let .reaction(messageId, reaction):
            applyReaction(messageId: messageId, reaction: reaction)
            try await Task.sleep(for: .milliseconds(400))
            noteAIActivity()
          }
        }
        showDisplayTypingIndicator = false
      } catch let error as LLMService.LLMError {
        print("Error sending message: \(error)")
        showDisplayTypingIndicator = false
        let errorMessage = Message(isUser: false, content: "Sorry, I did not quite catch that. Could you please repeat?")
        messages.append(errorMessage)
      } catch {
        print("Unexpected error sending message: \(error)")
        showDisplayTypingIndicator = false
      }
    }
  }

  public func resetChat() {
    messages = []
    onlineStatus = .offline
    showDisplayTypingIndicator = false
  }

  private func applyReaction(messageId: String, reaction: Reaction) {
    guard let index = messages.firstIndex(where: { $0.id == messageId }) else {
      print("Warning: Could not find message with id \(messageId)")
      return
    }
    messages[index].reaction = reaction
  }

  // MARK: - Online Status Management

  private func awaitOnlineTransitionIfNeeded() async {
    guard case .online = onlineStatus else {
      onlineTransitionTask?.cancel()
      let task = Task { [weak self] in
        let delay = Double.random(in: 0.3 ... 1.1)
        try? await Task.sleep(for: .seconds(delay))
        guard !Task.isCancelled else { return }
        self?.onlineStatus = .online
      }
      onlineTransitionTask = task
      await task.value
      return
    }
  }

  private func noteAIActivity() {
    onlineTransitionTask?.cancel()
    offlineTransitionTask?.cancel()
    onlineStatus = .online
    lastAIActivityAt = .now
    resetInactivityTimer()
  }

  private func resetInactivityTimer() {
    inactivityTask?.cancel()
    offlineTransitionTask?.cancel()
    inactivityTask = Task { [weak self] in
      try? await Task.sleep(for: .seconds(10))
      guard !Task.isCancelled else { return }
      self?.onlineStatus = .lastSeen
      self?.scheduleOfflineTransition()
    }
  }

  private func scheduleOfflineTransition() {
    offlineTransitionTask?.cancel()
    offlineTransitionTask = Task { [weak self] in
      try? await Task.sleep(for: .seconds(10))
      guard let self, !Task.isCancelled else { return }
      if case .lastSeen = self.onlineStatus {
        self.onlineStatus = .offline
      }
    }
  }

  private func typingDelaySeconds(for content: String) -> Double {
    let clampedCount = min(max(content.count, 12), 120)
    let baseDelay = Double(clampedCount) * 0.035
    let jitter = Double.random(in: 0.12 ... 0.35)
    return min(max(baseDelay + jitter, 0.4), 2.2)
  }
}
