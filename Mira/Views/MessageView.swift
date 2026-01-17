//
//  MessageView.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

struct MessageView: View {
  @Binding var message: Message

  var body: some View {
    VStack(alignment: message.isUser ? .trailing : .leading, spacing: 0) {
      messageContentView
      reactionView
      timestampView
    }
    .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    .multilineTextAlignment(message.isUser ? .trailing : .leading)
    .transition(.opacity.combined(with: .move(edge: message.isUser ? .trailing : .leading)))
  }

  private var messageContentView: some View {
    Text(message.content)
      .padding(.horizontal)
      .padding(.vertical, 8)
      .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
      .foregroundColor(message.isUser ? .white : .primary)
      .clipShape(RoundedRectangle(cornerRadius: 22))
      .frame(maxWidth: 310, alignment: message.isUser ? .trailing : .leading)
      .contextMenu {
        reactionContextMenu
      }
  }

  @ViewBuilder
  private var reactionContextMenu: some View {
    if !message.isUser {
      ForEach(Reaction.allCases, id: \.rawValue) { reaction in
        Button(
          action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
              message.reaction = reaction
            }
          },
          label: {
            Text(reaction.completeName)
          }
        )
      }
    }
  }

  @ViewBuilder
  private var reactionView: some View {
    if let reaction = message.reaction {
      Text(reaction.emoji)
        .font(.system(size: 11))
        .frame(width: 24, height: 24)
        .background(reaction.color.opacity(0.2))
        .clipShape(.circle)
        .transition(.scale.combined(with: .opacity))
    }
  }

  private var timestampView: some View {
    Text(message.date, format: .dateTime.minute().hour())
      .font(.caption2)
      .foregroundColor(.secondary)
      .padding(.top, 2)
  }
}

#Preview {
  ScrollView {
    MessageView(message: .constant(.init(isUser: true, content: "test", reaction: .surprised)))
    MessageView(message: .constant(.init(isUser: false, content: "test")))
  }
  .scrollClipDisabled()
  .padding()
}
