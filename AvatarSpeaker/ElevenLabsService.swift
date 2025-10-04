//
//  ElevenLabsService.swift
//  AvatarSpeaker
//
//  Created by Neha S on 04/10/25.
//

import Foundation

class ElevenLabsService {
    static let shared = ElevenLabsService()
    private init() {}

    private let apiKey = "sk_b3946f0be39d88d1cd800877535a7bc994d4ad8030a3e584" //elevenlabs api key
    private let voiceId = "JBFqnCBsd6RMkjVDRZzb" //default voice id ''"YOUR_VOICE_ID"

    func synthesizeSpeech(from text: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/\(voiceId)") else {
            completion(nil); return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

        let body: [String: Any] = [
            "text": text,
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent("speech.mp3")
            try? data.write(to: tempFile)
            completion(tempFile)
        }.resume()
    }
}
