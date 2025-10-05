//
//  VideoScreen.swift
//  AvatarSpeaker
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoScreen: View {
    let player: AVPlayer
    @StateObject private var streamSubscriber: StreamSubscriber
    @State private var showSuggestion = false
    @State private var currentSuggestion = ""
    @State private var suggestionTimer: Timer?
    @State private var sessionId: String

    // Mock suggestions that would come from your website
    let suggestions = [
        "Keep your back straight during this exercise",
        "Focus on controlled movements",
        "Breathe steadily throughout the exercise",
        "Engage your core muscles",
        "Maintain proper form for maximum benefit"
    ]
    
    init(player: AVPlayer, sessionId: String) {
        self.player = player
        self._sessionId = State(initialValue: sessionId)
        self._streamSubscriber = StateObject(wrappedValue: StreamSubscriber(sessionId: sessionId))
    }

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            // Live Stream Window in corner
            VStack {
                HStack {
                    Spacer() // push video to right

                    // Display WebSocket video stream
                    LiveStreamView(subscriber: streamSubscriber)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .onAppear {
                            Task {
                                await streamSubscriber.connect()
                            }
                            startSuggestionTimer()
                        }
                        .onDisappear {
                            streamSubscriber.disconnect()
                            suggestionTimer?.invalidate()
                        }
                        .padding(.top, 25)       // move down 25 points
                        .padding(.trailing, 25)  // move left 25 points
                }
                Spacer() // push video to top
            }
            .padding()

            // Suggestion popup in the middle
            if showSuggestion {
                VStack {
                    Spacer()

                    SuggestionPopup(
                        text: currentSuggestion,
                        isVisible: $showSuggestion
                    )

                    Spacer()
                }
            }
        }
    }

    private func startSuggestionTimer() {
        suggestionTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
            showNextSuggestion()
        }

        // Show first suggestion after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showNextSuggestion()
        }
    }

    private func showNextSuggestion() {
        currentSuggestion = suggestions.randomElement() ?? "Keep up the great work!"

        withAnimation(.easeInOut(duration: 0.5)) {
            showSuggestion = true
        }

        // Convert text to speech using ElevenLabs
        ElevenLabsService.shared.synthesizeSpeech(from: currentSuggestion) { url in
            if let url = url {
                // Play the audio
                do {
                    let audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer.play()
                } catch {
                    print("Error playing suggestion audio: \(error)")
                }
            }
        }

        // Hide suggestion after 6 seconds (longer to account for speech)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showSuggestion = false
            }
        }
    }
}

