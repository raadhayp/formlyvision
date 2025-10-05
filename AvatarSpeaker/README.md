# AvatarSpeaker - Modular Architecture

## 📁 Project Structure

```
AvatarSpeaker/
├── Models/                    # Data models and app state
│   └── AppModel.swift        # App-wide state management
│
├── Views/                     # All UI components
│   ├── Screens/              # Full-screen views
│   │   ├── WelcomeScreen.swift    # Landing/welcome screen
│   │   └── VideoScreen.swift      # Main video streaming screen
│   │
│   └── Components/           # Reusable UI components
│       ├── LiveStreamView.swift       # WebSocket video stream display
│       ├── SuggestionPopup.swift     # Exercise suggestion overlay
│       └── CircularVideoPlayer.swift # Video player with circular mask
│
├── Services/                  # Business logic and external services
│   ├── StreamSubscriber.swift       # Ably WebSocket stream handler
│   ├── WebSocketAuthService.swift   # WebSocket authentication
│   └── ElevenLabsService.swift      # Text-to-speech service
│
├── Managers/                  # State and resource management
│   └── AvatarManager.swift   # Avatar loading and animation
│
├── ContentView.swift          # Main app entry view
├── AvatarSpeakerApp.swift    # App lifecycle and configuration
├── ImmersiveView.swift       # VisionOS immersive space view
└── ToggleImmersiveSpaceButton.swift  # Immersive mode toggle
```

## 🏗️ Architecture Overview

### Models

Contains data structures and application-wide state management.

- **AppModel**: Manages immersive space state for VisionOS

### Views

All SwiftUI views organized by hierarchy:

#### Screens

Full-screen views that represent major app states:

- **WelcomeScreen**: Initial landing page with branding and start button
- **VideoScreen**: Main screen showing live stream and exercise suggestions

#### Components

Reusable UI components:

- **LiveStreamView**: Displays real-time video from WebSocket with connection status
- **SuggestionPopup**: Animated popup showing exercise form suggestions
- **CircularVideoPlayer**: UIKit-based circular video player wrapper

### Services

External integrations and network services:

- **StreamSubscriber**: Manages Ably WebSocket connection and frame reception
- **WebSocketAuthService**: Handles authentication for WebSocket connection
- **ElevenLabsService**: Text-to-speech synthesis for audio suggestions

### Managers

Resource and state management:

- **AvatarManager**: Loads and controls 3D avatar entities

## 🔄 Data Flow

```
Web App Camera
    ↓
WebSocket (Ably)
    ↓
StreamSubscriber (Service)
    ↓
LiveStreamView (Component)
    ↓
VideoScreen (Screen)
```

## 🎯 Key Features

1. **Real-time Video Streaming**: WebSocket-based live video from web camera
2. **Exercise Suggestions**: AI-powered form corrections with voice feedback
3. **VisionOS Integration**: Immersive space support for Vision Pro
4. **Modular Design**: Clean separation of concerns for easy maintenance

## 🚀 Getting Started

1. Ensure your backend is running at `http://localhost:3000`
2. The app will automatically generate a unique session ID
3. Press "Start" to begin streaming
4. Exercise suggestions will appear with audio feedback

## 📝 Notes

- The app uses Ably for WebSocket communication
- ElevenLabs API provides text-to-speech functionality
- Session IDs are generated client-side using UUID
- All services are dependency-injection ready for testing
