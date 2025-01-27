//
//  GameView.swift
//  Online HardR
//
//  Created by Dias Atudinov on 27.01.2025.
//


import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var valueName = "-"
    @State var achivement1 = false
    @State var coinsCount = 0
    @State var starsCount = 0
    
    let skView = SKView()
    @State var gameScene = GameScene(size: SKView().bounds.size)
    
    @State private var gameOver = false
    @State private var isPause = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                GameSceneView(skView: skView, gameScene: gameScene).ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("")
                    }
                }
                
            }
        }.background(
            ZStack {
                Image(.checkBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
            
        )
        
    }
}

#Preview {
    GameView()
}
