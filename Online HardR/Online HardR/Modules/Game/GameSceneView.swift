//
//  GameSceneView.swift
//  Online HardR
//
//  Created by Dias Atudinov on 27.01.2025.
//


import SwiftUI
import SpriteKit



struct GameSceneView: UIViewRepresentable {
    var skView: SKView
    var gameScene: GameScene
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = gameScene
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.backgroundColor = .clear
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        //
    }
    

}
