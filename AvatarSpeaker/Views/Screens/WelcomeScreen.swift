//
//  WelcomeScreen.swift
//  AvatarSpeaker
//

import SwiftUI

struct WelcomeScreen: View {
    @Binding var showVideoScreen: Bool

    var body: some View {
        ZStack {
            // Light off-white background with subtle texture
            Color(red: 0.98, green: 0.98, blue: 0.97)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Brand name
                Text("Formly")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))

                // Tagline
                Text("Perfect your form, accelerate recovery")
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.3))

                Spacer()
                
                // Start Camera button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showVideoScreen = true
                    }
                }) {
                    Label("Start", systemImage: "camera.fill")
                        .font(.system(size: 18, weight: .semibold))
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 1.0, green: 0.6, blue: 0.2))
                .controlSize(.large)

                Spacer()

                // Pagination dots
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)

                    Circle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 8, height: 8)

                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

