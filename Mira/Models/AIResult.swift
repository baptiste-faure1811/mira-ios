//
//  AIResult.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import AIProxy
import Foundation

enum LLMResult: Hashable {
  case message(String)
  case reaction(messageId: String, reaction: Reaction)
}

// MARK: - Schema
extension LLMResult {
  static var schema: AIProxyJSONValue = .object([
    "type": "object",
    "description": "",
    "properties": [
      "type": [
        "type": "string",
        "description": "The type of response",
        "enum": ["message", "reaction"],
      ],
      "generated_data": [
        "anyOf": [
          [
            "type": "string",
            "description": "The message content",
          ],
          [
            "type": "object",
            "description": "The reaction data",
            "properties": [
              "message_id": [
                "type": "string",
                "description": "The message id to which the reaction is attached to",
              ],
              "reaction_raw_value": [
                "type": "string",
                "description": "The reaction raw value",
                "enum": ["thumbs_up", "thumbs_down", "laugh", "surprised", "heart"],
              ],
            ],
            "required": ["message_id", "reaction_raw_value"],
            "additionalProperties": false,
          ],
        ],
      ],
    ],
    "required": ["type", "generated_data"],
    "additionalProperties": false,
  ])
}

// MARK: - Codable

extension LLMResult: Codable {
  enum CodingKeys: String, CodingKey {
    case type
    case generatedData = "generated_data"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(String.self, forKey: .type)

    switch type {
    case "message":
      let messageContent = try container.decode(String.self, forKey: .generatedData)
      guard !messageContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        throw DecodingError.dataCorrupted(
          DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Message content cannot be null or empty for message type")
        )
      }
      self = .message(messageContent)
    case "reaction":
      let reactionPayload = try container.decode(ReactionPayload.self, forKey: .generatedData)
      self = .reaction(messageId: reactionPayload.messageId, reaction: reactionPayload.reaction)
    default:
      throw DecodingError.dataCorrupted(
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown type: \(type)")
      )
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case let .message(messageContent):
      try container.encode("message", forKey: .type)
      try container.encode(messageContent, forKey: .generatedData)
    case let .reaction(messageId, reaction):
      try container.encode("reaction", forKey: .type)
      try container.encode(ReactionPayload(messageId: messageId, reaction: reaction), forKey: .generatedData)
    }
  }
}

struct ReactionPayload: Codable {
  let messageId: String
  let reaction: Reaction

  enum CodingKeys: String, CodingKey {
    case messageId = "message_id"
    case reactionRawValue = "reaction_raw_value"
  }

  init(messageId: String, reaction: Reaction) {
    self.messageId = messageId
    self.reaction = reaction
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let decodedMessageId = try? container.decode(String.self, forKey: .messageId) {
      let trimmedId = decodedMessageId.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmedId.isEmpty else {
        throw DecodingError.dataCorrupted(
          DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Message ID cannot be null or empty for reaction type")
        )
      }
      messageId = trimmedId
    } else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Message ID cannot be null or empty for reaction type"
        )
      )
    }

    let reactionRawValue = try container.decode(String.self, forKey: .reactionRawValue)
    guard let reaction = Reaction(rawValue: reactionRawValue) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown reaction: \(reactionRawValue)")
      )
    }
    self.reaction = reaction
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(messageId, forKey: .messageId)
    try container.encode(reaction.rawValue, forKey: .reactionRawValue)
  }
}
