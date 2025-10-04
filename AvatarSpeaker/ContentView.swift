//
//  ContentView.swift
//  AvatarSpeaker
//
//  Created by Neha S on 04/10/25.
//

//import SwiftUI
//import RealityKit
//import RealityKitContent
//
//struct ContentView: View {
//
//    var body: some View {
//        VStack {
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .padding(.bottom, 50)
//
//            Text("Hello, world!")
//
//            ToggleImmersiveSpaceButton()
//        }
//        .padding()
//    }
//}
//
//#Preview(windowStyle: .automatic) {
//    ContentView()
//        .environment(AppModel())
//}

//import SwiftUI
//import RealityKit
//
//struct ContentView: View {
//    @StateObject private var avatarManager = AvatarManager()
//
//    var body: some View {
//        VStack {
//            RealityView { content in
//                if let avatar = avatarManager.avatarEntity {
//                    content.add(avatar)
//                }
//            }
//            .onAppear {
//                avatarManager.loadAvatar()
//                avatarManager.fetchAndSpeakMessage()
//            }
//        }
//    }
//}

//import SwiftUI
//import RealityKit
//
//struct ContentView: View {
//    @StateObject private var avatarManager = AvatarManager()
//
//    var body: some View {
//        RealityView { content in
//            // If the avatar has already been loaded, add it
//            if let avatar = avatarManager.avatarEntity {
//                content.add(avatar)
//            }
//        }
//        .onAppear {
//            // Load once at startup
//            if avatarManager.avatarEntity == nil {
//                if let avatar = try? Entity.load(named: "avatar.usdz") {
//                    // 🔹 Shrink the model down
//                    avatar.scale = SIMD3<Float>(repeating: 1.0)
//
////                    // 🔹 Position it a little forward so it's visible
////                    avatar.position = SIMD3<Float>(0, 0, -1.0)
//
//                    avatarManager.avatarEntity = avatar
//                }
//            }
//
//            // Start ElevenLabs speech once avatar is loaded
//            avatarManager.fetchAndSpeakMessage()
//        }
//    }
//}

//
//import SwiftUI
//import RealityKit
//
//struct ContentView: View {
//    @StateObject private var avatarManager = AvatarManager()
//
//    var body: some View {
//        RealityView { content in
//            if let avatar = avatarManager.avatarEntity {
//                print("✅ Adding avatar to scene")
//                content.add(avatar)
//            } else {
//                print("⚠️ Avatar entity is nil")
//            }
//        }
//        .onAppear {
//            if avatarManager.avatarEntity == nil {
//                do {
//                    let avatar = try Entity.load(named: "avatar.usdz")
//                    print("✅ Loaded avatar.usdz successfully")
////                    avatar.scale = SIMD3<Float>(repeating: 0.7)
////                    avatar.position = SIMD3<Float>(0, -0.5, 0)    // 30cm in front
////
////                    print("✅ position= ", avatar.position)
////                    avatar.scale = SIMD3<Float>(repeating: 0.7)
////                    avatar.position = SIMD3<Float>(0, -50, 0)
////                    avatar.scale = SIMD3<Float>(repeating: 1.0)   // full scale
////                    avatar.position = SIMD3<Float>(0, 0, 0)    // 30cm in front
//
////                    let cube = ModelEntity(mesh: .generateBox(size: 0.2))
////                    cube.position = SIMD3<Float>(0, 0, -0.5)
////                    content.add(cube)
//
//                    avatarManager.avatarEntity = avatar
//                } catch {
//                    print("❌ Failed to load avatar.usdz: \(error)")
//
//                    // Test with fallback cube
//                    let cube = ModelEntity(mesh: .generateBox(size: 0.2))
//                    cube.position = SIMD3<Float>(0, 0, -0.5)
//                    avatarManager.avatarEntity = cube
//                }
//            }
//
//            avatarManager.fetchAndSpeakMessage()
//        }
//    }
//}

//import SwiftUI
//import AVKit
//
//struct ContentView: View {
//    // Load your video from bundle
//    let player: AVPlayer = {
//        guard let url = Bundle.main.url(forResource: "hips_trial", withExtension: "mp4") else {
//            fatalError("Video not found")
//        }
//        let player = AVPlayer(url: url)
//        player.isMuted = true       // mute audio
//        player.actionAtItemEnd = .none
//        return player
//    }()
//
//    var body: some View {
//        ZStack {
//            Color.clear.ignoresSafeArea() // transparent background
//
//            VStack {
//                HStack {
//                    VideoPlayer(player: player)
//                        .frame(width: 300, height: 300) // adjust size
//                        .cornerRadius(12)
//                        .shadow(radius: 5)
//                        .onAppear {
//                            player.play()
//                            // Loop video
//                            NotificationCenter.default.addObserver(
//                                forName: .AVPlayerItemDidPlayToEndTime,
//                                object: player.currentItem,
//                                queue: .main
//                            ) { _ in
//                                player.seek(to: .zero)
//                                player.play()
//                            }
//                        }
//
//                    Spacer() // push to left
//                }
//                Spacer() // push to top
//            }
//            .padding()
//        }
//    }
//}

import SwiftUI
import AVKit
import AVFoundation

struct CircularVideoPlayer: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> CircularVideoView {
        let view = CircularVideoView()
        view.setupPlayer(player)
        return view
    }

    func updateUIView(_ uiView: CircularVideoView, context: Context) {
        // No updates needed
    }
}

class CircularVideoView: UIView {
    private var playerLayer: AVPlayerLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 100
        clipsToBounds = true
        isUserInteractionEnabled = false
    }

    func setupPlayer(_ player: AVPlayer) {
        // Remove existing layer if any
        playerLayer?.removeFromSuperlayer()

        // Create new player layer
        let newPlayerLayer = AVPlayerLayer(player: player)
        newPlayerLayer.videoGravity = .resizeAspect
        newPlayerLayer.isOpaque = true
        newPlayerLayer.pixelBufferAttributes = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]

        layer.addSublayer(newPlayerLayer)
        playerLayer = newPlayerLayer

        // Start playing
        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

struct ContentView: View {
    @State private var showVideoScreen = false

    // Load your video
    let player: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "hips_trial", withExtension: "mp4") else {
            fatalError("Video not found")
        }
        let player = AVPlayer(url: url)
        player.isMuted = true       // mute audio
        player.actionAtItemEnd = .none
        return player
    }()

    var body: some View {
        if showVideoScreen {
            VideoScreen(player: player)
        } else {
            WelcomeScreen(showVideoScreen: $showVideoScreen)
        }
    }
}

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
                    HStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))

                        Text("Start Camera")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color(red: 1.0, green: 0.6, blue: 0.2)) // Orange color
                    .cornerRadius(12)
                }

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

struct VideoScreen: View {
    let player: AVPlayer
    @State private var showSuggestion = false
    @State private var currentSuggestion = ""
    @State private var suggestionTimer: Timer?

    // Mock suggestions that would come from your website
    let suggestions = [
        "Keep your back straight during this exercise",
        "Focus on controlled movements",
        "Breathe steadily throughout the exercise",
        "Engage your core muscles",
        "Maintain proper form for maximum benefit"
    ]

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            // Video back in corner
            VStack {
                HStack {
                    Spacer() // push video to right

                    CircularVideoPlayer(player: player)
                        .frame(width: 200, height: 200)
                        .shadow(radius: 5)
                        .onAppear {
                            // Disable video controls
                            player.volume = 0.0 // Ensure video is muted
                            startSuggestionTimer()

                            // Loop video
                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: player.currentItem,
                                queue: .main
                            ) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                        .onDisappear {
                            suggestionTimer?.invalidate()
                        }
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
