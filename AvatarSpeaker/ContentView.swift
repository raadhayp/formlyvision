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
    private var haloLayer: CALayer?
    private let circleContainer = UIView()

    // Hardcoded test score (1=red, 2=yellow, 3=green)
    private let score = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = false

        // --- Halo Layer ---
        let haloColor: UIColor
        switch score {
        case 1: haloColor = .red
        case 2: haloColor = .yellow
        case 3: haloColor = .green
        default: haloColor = .gray
        }

        let halo = CALayer()
        halo.frame = bounds
        halo.cornerRadius = bounds.width / 2
        halo.backgroundColor = haloColor.withAlphaComponent(0.4).cgColor  // soft tint fill
        halo.shadowColor = haloColor.cgColor
        halo.shadowOpacity = 1.0
        halo.shadowRadius = 25
        halo.shadowOffset = .zero
        halo.masksToBounds = false

        layer.addSublayer(halo)
        haloLayer = halo

        // --- Circle Container (clipped video area) ---
        circleContainer.frame = bounds
        circleContainer.backgroundColor = .white
        circleContainer.layer.cornerRadius = bounds.width / 2
        circleContainer.clipsToBounds = true
        addSubview(circleContainer)
    }

    func setupPlayer(_ player: AVPlayer) {
        playerLayer?.removeFromSuperlayer()

        let newPlayerLayer = AVPlayerLayer(player: player)
        newPlayerLayer.frame = circleContainer.bounds
        newPlayerLayer.videoGravity = .resizeAspect
        newPlayerLayer.isOpaque = true

        circleContainer.layer.addSublayer(newPlayerLayer)
        playerLayer = newPlayerLayer
        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        haloLayer?.frame = bounds
        haloLayer?.cornerRadius = bounds.width / 2
        circleContainer.frame = bounds
        circleContainer.layer.cornerRadius = bounds.width / 2
        playerLayer?.frame = circleContainer.bounds
    }
}




struct ContentView: View {
    @State private var showVideoScreen = false

    // Load your video
    let player: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "frontraise", withExtension: "mp4") else {
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

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showVideoScreen = true
                    }
                }) {
                    Label("Start", systemImage: "camera.fill")
                        .font(.system(size: 18, weight: .semibold))
                }
                .buttonStyle(.borderedProminent) // use system rounded shape
                .tint(Color(red: 1.0, green: 0.6, blue: 0.2)) // make it orange
                .controlSize(.large) // optional: gives it that smooth rounded large look

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
                        .padding(.top, 25)       // 👈 move down 40 points
                        .padding(.trailing, 25)  // 👈 move left 40 points
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
