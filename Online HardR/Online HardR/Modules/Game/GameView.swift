import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var teamVM: TeamViewModel
    @State var valueName = "-"
    @State var achivement1 = false
    @State var coinsCount = 0
    @State var starsCount = 0
    
    @State var handler: GameSceneDelegate?
    let skView = SKView()
    @State var gameScene = GameScene(size: SKView().bounds.size)
    
    @State private var gameOver = false
    @State private var isPause = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GameSceneView(teamVM: teamVM, coinsCount: $coinsCount, starsCount: $starsCount, skView: skView, gameScene: gameScene, gameOver: $gameOver).ignoresSafeArea()
                
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 0) {
                                
                                ZStack {
                                    Image(.gameCoinBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                    
                                    Text("\(coinsCount)")
                                        .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                }
                                
                                ZStack {
                                    Image(.gameStarBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                    
                                    Text("\(starsCount)")
                                        .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                }
                            }.padding()
                        }
                        
                        HStack {
                            Button {
                                isPause = true
                                handler?.pause()
                            } label: {
                                Image(.pause)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 75 : 50)
                            }
                            Spacer()
                        }.padding()
                    }
                    Spacer()
                }
                
                if isPause {
                    ZStack {
                        Image(.pauseBg)
                            .resizable()
                            .scaledToFit()
                            
                        VStack {
                            Button {
                                handler?.resume()
                                isPause = false
                            } label: {
                                TextBg(height: 60, text: "Resume", textSize: 20)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                TextBg(height: 60, text: "Menu", textSize: 20)
                            }
                        }
                    }.frame(height: 262)
                }
                
                if gameOver {
                    ZStack {
                        Image(.overBg)
                            .resizable()
                            .scaledToFit()
                            
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                
                                ZStack {
                                    Image(.gameCoinBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                    
                                    Text("+\(coinsCount)")
                                        .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                }
                                
                                ZStack {
                                    Image(.gameStarBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                    
                                    Text("+\(starsCount)")
                                        .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                }
                            }
                            Button {
                                handler?.restart()
                                starsCount = 0
                                coinsCount = 0
                                gameOver = false
                            } label: {
                                TextBg(height: 60, text: "Retry", textSize: 20)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                TextBg(height: 60, text: "Menu", textSize: 20)
                            }
                        }
                    }.frame(height: 340)
                }
                
            }
            .background(
                Image(.gameBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            )
            .onAppear {
                    self.handler = gameScene
                
            }
            
            
        }
    }
}

#Preview {
    GameView(teamVM: TeamViewModel())
}
