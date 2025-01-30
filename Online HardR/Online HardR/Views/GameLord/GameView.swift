import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var valueName = "-"
    @State var achivement1 = false
    @State var player1Score = 0
    @State var player2Score = 0
    
    let skView = SKView()
    @State var gameScene = GameScene(size: SKView().bounds.size)
    
    @State private var gameOver = false
    @State private var isPause = false
    
    @State private var currentPlayer1 = true
    @ObservedObject var shopVM: SVM
    var opponentState: GameState
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                GameSceneView(
                    skView: skView,
                    gameScene: gameScene,
                    playerChecks: shopVM.currentItem?.images ?? [],
                    opponentChecks: shopVM.getRandomItem(),
                    currentPlayer1: $currentPlayer1,
                    player1Score: $player1Score,
                    player2Score: $player2Score,
                    opponentState: opponentState
                )
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        VStack {
                            VStack(alignment: .leading, spacing: 0) {
                                TextWithBorder(text: "Player 1", font: .system(size: 30, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                                    .textCase(.uppercase)
                                Image(currentPlayer1 ? .p1Go : .p1Wait)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                
                            }
                            TextWithBorder(text: currentPlayer1 ? "go!":"wait...", font: .system(size: 20, weight: .bold), textColor: .darkPurple, borderColor: .white, borderWidth: 2)
                                .textCase(.uppercase)
                        }
                        Spacer()
                        VStack {
                            VStack(alignment: .trailing, spacing: 0) {
                                TextWithBorder(text: "Player 2", font: .system(size: 30, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                                    .textCase(.uppercase)
                                Image(currentPlayer1 ? .p2Wait : .p2Go)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                
                            }
                            TextWithBorder(text: !currentPlayer1 ? "go!":"wait...", font: .system(size: 20, weight: .bold), textColor: .darkPurple, borderColor: .white, borderWidth: 2)
                                .textCase(.uppercase)
                        }
                    }
                    Spacer()
                    HStack {
                        
                        ZStack {
                            Image(.score)
                                .resizable()
                                .scaledToFit()
                                
                            Text("\(player1Score):\(player2Score)").padding(.top, 30)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(.darkPurple)
                            
                        }.frame(height: 110).offset(y: -100)
                        Spacer()
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(.goHome)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                    }
                }.padding().ignoresSafeArea(edges: .bottom)
                
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
    GameView(shopVM: SVM(), opponentState: .player)
}
