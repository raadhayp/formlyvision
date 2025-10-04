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

struct ContentView: View {
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
        ZStack {
            Color.clear.ignoresSafeArea() // transparent background

            VStack {
                HStack {
                    Spacer() // push video to right

                    ZStack {
                        // White circular background
                        Circle()
                            .fill(Color.white)
                            .frame(width: 200, height: 200)

                        // Video player that fills the circle
                        VideoPlayer(player: player)
                            .frame(width: 200, height: 200)
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(Circle())
                    }
                    .shadow(radius: 5)
                    .onAppear {
                        player.play()
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
                }
                Spacer() // push video to top
            }
            .padding()
        }
    }
}
