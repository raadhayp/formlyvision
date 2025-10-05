//
//  SuggestionPopup.swift
//  AvatarSpeaker
//

import SwiftUI

struct SuggestionPopup: View {
    let text: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)

            // Suggestion text
            Text(text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
    }
}

