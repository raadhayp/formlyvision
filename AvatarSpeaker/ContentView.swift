//
//  ContentView.swift
//  AvatarSpeaker
//
//  Created by Neha S on 04/10/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var showVideoScreen = false
    @State private var sessionId = UUID().uuidString  // Generate unique session ID

    // Load your video
    let player: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "frontraise", withExtension: "mp4") else {
            fatalError("Video not found")
        }
        let player = AVPlayer(url: url)
        player.isMuted = true       // mute audio
        player.actionAtItemEnd = .none
        return player
    }()

    var body: some View {
        if showVideoScreen {
            VideoScreen(player: player, sessionId: sessionId)
        } else {
            WelcomeScreen(showVideoScreen: $showVideoScreen)
        }
    }
}
