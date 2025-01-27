import SwiftUI
import SpriteKit



struct GameSceneView: UIViewRepresentable {
    @StateObject var user = User.shared
    @StateObject var teamVM: TeamViewModel
    @Binding var coinsCount: Int
    @Binding var starsCount: Int
    var delegate: GameSceneDelegate?
    var skView: SKView
    var gameScene: GameScene
    @Binding var gameOver: Bool
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = gameScene
        scene.scaleMode = .resizeFill
        scene.gameOverHandler = {
            gameOver = true
            user.updateUserCoins(for: coinsCount + starsCount)
            teamVM.addScore(points: coinsCount + starsCount)
            print("added \(coinsCount + starsCount) coins")
        }
        scene.coinsUpdateHandler = {
            coinsCount += 1
        }
        
        scene.starsUpdateHandler = {
            starsCount += 1
        }
//        scene.currentValueUpdateHandler = { name in
//            DispatchQueue.main.async {
//                valueName = name
//            }
//        }
//        scene.finished3rdLevel = { mistake in
//            if !mistake {
//                achivement1 = true
//            }
//        }
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.backgroundColor = .clear
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        //
    }
    

}
