//
//  WebSocketAuthService.swift
//  AvatarSpeaker
//

import Ably
import Foundation

// Create a service to fetch auth token
struct WebSocketAuthService {
    let baseURL = "http://localhost:3000"
    
    // Return the token request as a dictionary that Ably can use
    func getAuthTokenData(sessionId: String) async throws -> [String: Any] {
        let url = URL(string: "\(baseURL)/api/ably/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["sessionId": sessionId]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Parse JSON response into dictionary
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "WebSocketAuthService", code: -1, 
                         userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])
        }
        
        return json
    }
}

