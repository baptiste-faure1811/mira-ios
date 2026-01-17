//
//  MessageTextField.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

struct ChatTextField: View {

  public let onSubmitMessage: (String) -> Void

  @State private var message: String = .init()
  @FocusState private var isFocused: Bool

  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      textField
      sendButton
    }
    .fixedSize(horizontal: false, vertical: true)
    .padding([.vertical, .trailing], 8)
    .padding(.leading, 20)
    .background(.quinary)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .onAppear { isFocused = true }
  }

  private var textField: some View {
    TextField("Enter your message", text: $message, axis: .vertical)
      .font(.body)
      .lineLimit(1...5)
      .focused($isFocused)
      .multilineTextAlignment(.leading)
      .submitLabel(.return)
      .onSubmit {
        submitMessage()
      }
  }

  private var sendButton: some View {
    VStack(alignment: .center, spacing: 0) {
      Spacer(minLength: 0)
      Button {
        submitMessage()
      } label: {
        Image(systemName: "arrow.up")
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding(8)
          .background(canSend ? .blue : .secondary)
          .clipShape(Circle())
      }
      .disabled(!canSend)
    }
  }

  private var canSend: Bool {
    !message.isEmpty
  }

  private func submitMessage() {
    guard !message.isEmpty else { return }
    onSubmitMessage(message)
    message = String()
  }
}
