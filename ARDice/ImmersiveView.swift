//
//  ImmersiveView.swift
//  ARDice
//
//  Created by Chetan Dhowlaghar on 3/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

let diceMap = [
    [1,6],
    [4,3],
    [2,5]
]
struct ImmersiveView: View {
    var diceData: DiceData
    @State private var isDropped = false
    var body: some View {
        RealityView { content in
                // Add the initial RealityKit content
            let floor = ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(
                massProperties: .default,
                mode: .static
            )
            
            content.add(floor)
            
            if let diceModel = try? await Entity(named: "dice"), let dice = diceModel.children.first?.children.first {
                dice.scale = [0.1, 0.1, 0.1]
                dice.position.y = 0.5
                dice.position.z = -1
                
                dice.generateCollisionShapes(recursive: false)
                dice.components.set(InputTargetComponent())
                dice.components[PhysicsBodyComponent.self] = .init(
                    PhysicsBodyComponent(
                        massProperties: .default,
                        material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.01) ,
                        mode: .dynamic)
                    
                )
                dice.components[PhysicsMotionComponent.self] = .init()
                
                
                content.add(dice)
                
                let _ = content.subscribe(to: SceneEvents.Update.self) { event in
                    guard isDropped else {return}
                    guard let motion = dice.components[PhysicsMotionComponent.self] else {return}
                    
                    if simd_length(motion.linearVelocity) < 0.1 && simd_length(motion.angularVelocity) < 0.1 {
                        let xDirection = dice.convert(direction: SIMD3(x: 1, y: 0, z: 0), to: nil)
                        let yDirection = dice.convert(direction: SIMD3(x: 0, y: 1, z: 0), to: nil)
                        let zDirection = dice.convert(direction: SIMD3(x: 0, y: 0, z: 1), to: nil)
                        
                        let greatestDirection = [
                            0: xDirection.y,
                            1: yDirection.y,
                            2: zDirection.y
                        ]
                            .sorted(by: {abs($0.1) > abs($1.1)})[0]
                        
                        diceData.faceValue = diceMap[greatestDirection.key][greatestDirection.value > 0 ? 0 : 1]
                        
                    }
                }
            }
        }
        .gesture(dragGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
                //isDropped = false
//                if isDropped {
//                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//                        isDropped = false
//                    }
//                }
            }
            .onEnded { value in
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
                if !isDropped {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        isDropped = true
                    }
                }
             
            }
    }
}

#Preview {
    ImmersiveView(diceData: DiceData())
        .previewLayout(.sizeThatFits)
}
