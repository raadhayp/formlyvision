//
//  ContentView.swift
//  AvatarSpeaker
//
//  Created by Neha S on 04/10/25.
//

//import SwiftUI
//import RealityKit
//import RealityKitContent
//
//struct ContentView: View {
//
//    var body: some View {
//        VStack {
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .padding(.bottom, 50)
//
//            Text("Hello, world!")
//
//            ToggleImmersiveSpaceButton()
//        }
//        .padding()
//    }
//}
//
//#Preview(windowStyle: .automatic) {
//    ContentView()
//        .environment(AppModel())
//}

import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject private var avatarManager = AvatarManager()

    var body: some View {
        VStack {
            RealityView { content in
                if let avatar = avatarManager.avatarEntity {
                    content.add(avatar)
                }
            }
            .onAppear {
                avatarManager.loadAvatar()
                avatarManager.fetchAndSpeakMessage()
            }
        }
    }
}
