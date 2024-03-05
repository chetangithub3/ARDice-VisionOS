//
//  ARDiceApp.swift
//  ARDice
//
//  Created by Chetan Dhowlaghar on 3/4/24.
//

import SwiftUI

@Observable
class DiceData {
    var faceValue = 0
}

@main
struct ARDiceApp: App {
    
    @State var diceData = DiceData()
    
    var body: some Scene {
        WindowGroup {
            ContentView(diceData: diceData)
        }.windowStyle(.volumetric)
            .defaultSize(width: 100, height: 100)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(diceData: diceData)
        }
    }
}
