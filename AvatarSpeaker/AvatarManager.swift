//
//  AvatarManager.swift
//  AvatarSpeaker
//
//  Created by Neha S on 04/10/25.


//import Foundation
//import RealityKit
//import AVFoundation
//
//@MainActor
//class AvatarManager: ObservableObject {
//    @Published var avatarEntity: Entity?
//    private var audioPlayer: AVAudioPlayer?
//
//    func loadAvatar() {
//        // Load your avatar model from Assets
//        if let entity = try? Entity.load(named: "avatar.usdz") {
//            avatarEntity = entity
//        }
//    }
//
//    func fetchAndSpeakMessage() {
//        fetchMessage { [weak self] message in
//            guard let self = self, let text = message else { return }
//            ElevenLabsService.shared.synthesizeSpeech(from: text) { url in
//                guard let url = url else { return }
//                Task { @MainActor in
//                    self.playAudio(url: url)
//                    if let entity = self.avatarEntity {
//                        self.animateMouth(entity: entity)
//                    }
//                }
//            }
//        }
//    }
//
//    private func fetchMessage(completion: @escaping (String?) -> Void) {
//        guard let url = URL(string: "https://yourwebsite.com/get-latest-text") else {
//            completion(nil); return
//        }
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let data = data, let text = String(data: data, encoding: .utf8) {
//                completion(text)
//            } else {
//                completion(nil)
//            }
//        }.resume()
//    }
//
//    private func playAudio(url: URL) {
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.play()
//        } catch {
//            print("Error playing audio: \(error)")
//        }
//    }
//
//    private func animateMouth(entity: Entity) {
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            guard let player = self.audioPlayer, player.isPlaying else {
//                timer.invalidate()
//                return
//            }
//            // crude mouth bobbing animation
//            let amplitude = Float.random(in: 0...0.05)
//            entity.scale = SIMD3<Float>(1, 1 + amplitude, 1)
//        }
//    }
//}


import Foundation
import RealityKit
import AVFoundation

@MainActor
class AvatarManager: ObservableObject {
    @Published var avatarEntity: Entity?
    private var audioPlayer: AVAudioPlayer?
    
    // 🔹 Config toggle
    private let useMockMessage = true  // TODO: change to false when backend is ready
    
    // 🔹 Multiple mock test phrases
    private var mockMessages = [
        "Hello there! I am your visionOS avatar speaking with ElevenLabs.",
        "Testing another phrase to check timing and voice quality.",
        "This is a third example sentence to validate lip sync and playback."
    ]
    private var currentMockIndex = 0

    func loadAvatar() {
        if let entity = try? Entity.load(named: "avatar.usdz") {
            avatarEntity = entity
        }
    }

    func fetchAndSpeakMessage() {
        if useMockMessage {
            // ✅ Rotate through mock messages
            let text = mockMessages[currentMockIndex]
            currentMockIndex = (currentMockIndex + 1) % mockMessages.count
            speak(text: text)
        } else {
            // ✅ Real backend call
            fetchMessage { [weak self] message in
                guard let self = self, let text = message else { return }
                Task { @MainActor in
                    self.speak(text: text)
                }
            }
        }
    }

    private func fetchMessage(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://yourwebsite.com/get-latest-text") else {
            completion(nil); return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let text = String(data: data, encoding: .utf8) {
                completion(text)
            } else {
                completion(nil)
            }
        }.resume()
    }

    private func speak(text: String) {
        ElevenLabsService.shared.synthesizeSpeech(from: text) { [weak self] url in
            guard let self = self, let url = url else { return }
            Task { @MainActor in
                self.playAudio(url: url)
                if let entity = self.avatarEntity {
                    self.animateMouth(entity: entity)
                }
            }
        }
    }

    private func playAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    private func animateMouth(entity: Entity) {
        // ✅ Run timer on main thread so it can safely touch @MainActor state
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            Task { @MainActor in
                guard let player = self.audioPlayer, player.isPlaying else {
                    timer.invalidate()
                    return
                }
                // crude jaw bounce
                let amplitude = Float.random(in: 0...0.05)
                entity.scale = SIMD3<Float>(1, 1 + amplitude, 1)
            }
        }
    }
}
