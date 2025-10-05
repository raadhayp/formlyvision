//
//  AvatarManager.swift
//  AvatarSpeaker
//

import RealityKit
import Combine

class AvatarManager: ObservableObject {
    @Published var avatarEntity: Entity?
    
    func loadAvatar() {
        do {
            let avatar = try Entity.load(named: "avatar.usdz")
            avatar.scale = SIMD3<Float>(repeating: 1.0)
            avatar.position = SIMD3<Float>(0, 0, -1.0)
            self.avatarEntity = avatar
        } catch {
            print("Failed to load avatar: \(error)")
        }
    }
    
    func fetchAndSpeakMessage() {
        let message = "Hello! Welcome to Formly Vision."
        
        ElevenLabsService.shared.synthesizeSpeech(from: message) { url in
            guard let audioURL = url else {
                print("Failed to synthesize speech")
                return
            }
            
            // Play the audio (you can use AVAudioPlayer here)
            print("Audio ready at: \(audioURL)")
        }
    }
    
    func playAnimation(named animationName: String) {
        guard let avatar = avatarEntity else { return }
        
        // Find and play animation if it exists
        if let animation = avatar.availableAnimations.first(where: { $0.name == animationName }) {
            avatar.playAnimation(animation.repeat())
        }
    }
    
    func speak(text: String) {
        ElevenLabsService.shared.synthesizeSpeech(from: text) { url in
            if let audioURL = url {
                print("Speaking: \(text)")
                // Here you would play the audio and sync with avatar lip movements
            }
        }
    }
}

