//
//  Message.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import Foundation

struct Message: Identifiable, Hashable {
  var id: String = UUID().uuidString
  var isUser: Bool
  var content: String
  var date: Date = .init()
  var reaction: Reaction? = nil

  var llmDescription: String {
    return "Message ID: \(id) - Content: \(content)"
  }
}
