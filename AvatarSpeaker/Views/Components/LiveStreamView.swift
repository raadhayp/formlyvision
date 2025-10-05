//
//  LiveStreamView.swift
//  AvatarSpeaker
//

import SwiftUI

struct LiveStreamView: View {
    @ObservedObject var subscriber: StreamSubscriber
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.9)
            
            // Video Frame or Loading State
            if let frame = subscriber.latestFrame {
                Image(uiImage: frame)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    
                    Text(subscriber.isConnected ? "Loading stream..." : "Connecting...")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Connection Status Indicator
            VStack {
                HStack {
                    Circle()
                        .fill(subscriber.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text(subscriber.isConnected ? "LIVE" : "OFFLINE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
                .padding(8)
                
                Spacer()
            }
        }
    }
}

