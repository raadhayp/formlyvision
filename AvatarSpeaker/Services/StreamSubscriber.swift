//
//  StreamSubscriber.swift
//  AvatarSpeaker
//

import Ably
import UIKit

class StreamSubscriber: ObservableObject {
    @Published var latestFrame: UIImage?
    @Published var isConnected = false
    
    private var ably: ARTRealtime?
    private var channel: ARTRealtimeChannel?
    private let sessionId: String
    
    init(sessionId: String) {
        self.sessionId = sessionId
    }
    
    func connect() async {
        do {
            // Get auth token from your backend
            let authService = WebSocketAuthService()
            let tokenData = try await authService.getAuthTokenData(sessionId: sessionId)
            
            // Initialize Ably with token auth
            let options = ARTClientOptions()
            options.authCallback = { params, callback in
                do {
                    // Convert to NSDictionary for ARTJsonCompatible conformance
                    let nsDict = tokenData as NSDictionary
                    // Create ARTTokenRequest from JSON dictionary
                    let tokenRequest = try ARTTokenRequest.fromJson(nsDict)
                    callback(tokenRequest, nil)
                } catch {
                    callback(nil, error as NSError)
                }
            }
            
            ably = ARTRealtime(options: options)
            
            // Subscribe to the stream channel
            channel = ably?.channels.get("stream:\(sessionId)")
            
            // Listen for connection state
            ably?.connection.on { stateChange in
                if stateChange.current == .connected {
                    self.isConnected = true
                    print("✅ Connected to Ably stream")
                }
            }
            
            // Subscribe to video frames
            channel?.subscribe("video-frame") { message in
                self.handleVideoFrame(message)
            }
            
            // Subscribe to stream control events
            channel?.subscribe("stream-control") { message in
                self.handleStreamControl(message)
            }
            
        } catch {
            print("❌ Failed to connect: \(error)")
        }
    }
    
    private func handleVideoFrame(_ message: ARTMessage) {
        guard let data = message.data as? [String: Any],
              let frameBase64 = data["frame"] as? String,
              let frameData = Data(base64Encoded: frameBase64),
              let image = UIImage(data: frameData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.latestFrame = image
        }
    }
    
    private func handleStreamControl(_ message: ARTMessage) {
        guard let data = message.data as? [String: Any],
              let command = data["command"] as? String else {
            return
        }
        
        print("Stream control: \(command)")
        // Handle start/stop commands
    }
    
    func disconnect() {
        channel?.unsubscribe()
        ably?.close()
        isConnected = false
    }
}

