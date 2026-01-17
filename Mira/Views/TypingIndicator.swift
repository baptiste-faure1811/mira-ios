//
//  TypingIndicator.swift
//  Mira
//
//  Created by Baptiste Faure on 17/01/2026.
//

import SwiftUI

struct TypingIndicator: View {
  private let delays: [Double] = [0.1, 0.3, 0.6]

  var body: some View {
    HStack(spacing: 8) {
      ForEach(delays, id: \.self) { delay in
        TypingDot(size: 7, delay: delay)
      }
    }
    .padding(.all, 14)
    .background(.quinary)
    .clipShape(RoundedRectangle(cornerRadius: 24))
  }
}

private struct TypingDot: View {
  private let size: CGFloat
  private let delay: Double

  @State private var scale: CGFloat = 1.0
  @State private var opacity: Double = 0.5
  @State private var color: Color = .secondary

  init(size: CGFloat, delay: Double) {
    self.size = size
    self.delay = delay
  }

  var body: some View {
    Circle()
      .fill(color)
      .frame(width: size, height: size)
      .scaleEffect(scale)
      .opacity(opacity)
      .onAppear(perform: startBounceAnimation)
  }

  private func startBounceAnimation() {
    withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true).delay(delay)) {
      color = .secondary
      scale = 1.25
      opacity = 0.8
    }
  }
}

#Preview {
  TypingIndicator()
}
