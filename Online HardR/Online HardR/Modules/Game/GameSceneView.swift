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
    var playerChecks: [String]
    var opponentChecks: [String]
    
    @Binding var currentPlayer1: Bool
    @Binding var player1Score: Int
    @Binding var player2Score: Int
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = gameScene
        scene.scaleMode = .resizeFill
        scene.playerChecks = playerChecks
        scene.opponentChecks = opponentChecks
        scene.currentPlayerHandle = { currentPlayer in
            if currentPlayer == 1 {
                self.currentPlayer1 = true
            } else {
                self.currentPlayer1 = false
            }
        }
        scene.winnerHandle = { winner in
            if winner == 1 {
                player1Score += 1
            } else {
                player2Score += 1
            }
        }
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.backgroundColor = .clear
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        //
    }
    

}
