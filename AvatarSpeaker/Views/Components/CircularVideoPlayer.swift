//
//  CircularVideoPlayer.swift
//  AvatarSpeaker
//

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

        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

