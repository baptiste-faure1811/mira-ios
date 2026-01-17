//
//  ContentView.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

struct ChatView: View {
  @State private var viewModel = ChatViewModel()

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 2) {
        ForEach($viewModel.messages) { $message in
          MessageView(message: $message)
        }
        typingIndicator
      }
      .padding(.horizontal)
    }
    .animation(.default, value: viewModel.messages)
    .sensoryFeedback(.impact(weight: .medium, intensity: 1.0), trigger: viewModel.messages)
    .defaultScrollAnchor(.bottom)
    .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
      navigationBar
    }
    .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
      messageTextField
    }
  }

  private var navigationBar: some View {
    ChatNavigationBar(viewModel: viewModel)
      .padding()
      .background(Color(uiColor: .systemBackground))
  }

  private var messageTextField: some View {
    ChatTextField(onSubmitMessage: { message in
      viewModel.submitMessage(text: message)
    })
    .padding()
    .background(Color(uiColor: .systemBackground))
  }

  @ViewBuilder
  private var typingIndicator: some View {
    if viewModel.showDisplayTypingIndicator {
      TypingIndicator()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  ChatView()
}
