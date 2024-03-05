//
//  ContentView.swift
//  ARDice
//
//  Created by Chetan Dhowlaghar on 3/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    var diceData : DiceData
    var body: some View {
            VStack (spacing: 12) {
                Text(diceData.faceValue == 0 ?  "🎲" : "\(diceData.faceValue)")
                    .font(.custom("Menlo", size: 100))
                    .bold()
            }
            .frame(width: 360)
            .cornerRadius(10)
            .padding(36)
            .glassBackgroundEffect()
            .cornerRadius(10)
            
        
        .task {
            await openImmersiveSpace(id: "ImmersiveSpace")
            
        }
      
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView(diceData: DiceData())
}
