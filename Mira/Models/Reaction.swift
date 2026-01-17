//
//  Reaction.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

enum Reaction: String, Codable, Hashable, CaseIterable {
  case thumbsUp = "thumbs_up"
  case thumbsDown = "thumbs_down"
  case laugh
  case surprised
  case heart
  case hello

  var emoji: String {
    switch self {
    case .thumbsUp:
      return "👍"
    case .thumbsDown:
      return "👎"
    case .laugh:
      return "😂"
    case .surprised:
      return "😮"
    case .heart:
      return "❤️"
    case .hello:
      return "👋"
    }
  }
  
  var displayName: String {
    switch self {
    case .thumbsUp:
      return "Thumbs Up"
    case .thumbsDown:
      return "Thumbs Down"
    case .laugh:
      return "Laugh"
    case .surprised:
      return "Surprised"
    case .heart:
      return "Heart"
    case .hello:
      return "Hello"
    }
  }
  
  var color: Color {
    switch self {
    case .thumbsUp:
      return .green
    case .laugh, .thumbsDown, .hello:
      return .yellow
    case .surprised:
      return .orange
    case .heart:
      return .pink
    }
  }
  
  var completeName: String {
    return [emoji, displayName].joined(separator: " ")
  }
}
