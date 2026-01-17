//
//  OnlineStatus.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

enum OnlineStatus: Hashable {
  case online
  case offline
  case lastSeen

  var displayTitle: String {
    switch self {
    case .online:
      return "Online"
    case .offline:
      return "Offline"
    case .lastSeen:
      return "Last seen a few seconds ago"
    }
  }

  var color: Color {
    switch self {
    case .online:
      return .green
    case .offline:
      return .gray
    case .lastSeen:
      return .gray
    }
  }

}
