//
//  ElevenLabsService.swift
//  AvatarSpeaker
//

import Foundation

class ElevenLabsService {
    static let shared = ElevenLabsService()
    
    private let apiKey = "sk_ae90eed99ce47ad14e67b2a8a0ea1f57b19e4e1e4b8fc9c1"
    private let voiceId = "21m00Tcm4TlvDq8ikWAM" // Rachel voice
    
    func synthesizeSpeech(from text: String, completion: @escaping (URL?) -> Void) {
        let urlString = "https://api.elevenlabs.io/v1/text-to-speech/\(voiceId)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "text": text,
            "model_id": "eleven_monolingual_v1",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown")")
                completion(nil)
                return
            }
            
            // Save audio data to temporary file
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp3")
            try? data.write(to: tempURL)
            completion(tempURL)
        }.resume()
    }
}

