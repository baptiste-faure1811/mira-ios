//
//  MessageNavigationBar.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

struct ChatNavigationBar: View {

  private let viewModel: ChatViewModel

  init(viewModel: ChatViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      avatar
      nameAndStatus
      Spacer()
      ellipsisButton
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .animation(.default, value: viewModel.onlineStatus)
  }

  private var ellipsisButton: some View {
    Menu {
      Button {
        viewModel.resetChat()
      } label: {
        Text("Reset Chat")
      }
    } label: {
      Image(systemName: "ellipsis.circle")
        .font(.title2)
        .foregroundColor(.primary)
    }
  }

  private var avatar: some View {
    Image(systemName: "person.fill")
      .font(.title3)
      .foregroundColor(.blue)
      .padding(10)
      .background(Color.blue.tertiary)
      .clipShape(.circle)
      .grayscale(viewModel.onlineStatus == .online ? 0.0 : 1.0)
      .overlay(alignment: .bottomTrailing) {
        if viewModel.onlineStatus == .online {
          onlineBadge
        }
      }
  }

  private var nameAndStatus: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("Mira")
        .font(.title3)
        .fontWeight(.bold)
      Text(viewModel.onlineStatus.displayTitle)
        .font(.footnote)
        .fontWeight(.medium)
        .foregroundColor(viewModel.onlineStatus.color)
    }
    .contentTransition(.numericText())
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var onlineBadge: some View {
    Circle()
      .fill(Color.green)
      .frame(width: 12, height: 12)
      .overlay(
        Circle().stroke(Color(uiColor: .systemBackground), lineWidth: 2)
      )
  }
}

#Preview {
  let viewmodel = ChatViewModel()
  viewmodel.onlineStatus = .online
  return ChatNavigationBar(viewModel: viewmodel)
}
