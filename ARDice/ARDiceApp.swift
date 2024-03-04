//
//  ARDiceApp.swift
//  ARDice
//
//  Created by Chetan Dhowlaghar on 3/4/24.
//

import SwiftUI

@main
struct ARDiceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
