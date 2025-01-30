//
//  MenuView.swift
//  Online HardR
//
//  Created by Dias Atudinov on 29.01.2025.
//

import SwiftUI

struct MV: View {
    @State private var showAIGame = false
    @State private var showPlayerGame = false
    @State private var showShop = false
    @State private var showHowToPlay = false
    @State private var showSettings = false
    
    @StateObject var shopVM = SVM()
    @StateObject var settingsVM = SM()
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        
                        Image(.progressIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceCool.shared.deviceType == .pad ? 140:70)
                        
                        Spacer()
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(.settingsIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceCool.shared.deviceType == .pad ? 140:70)
                        }
                    }
                    Spacer()
                    
                    HStack {
                        Button {
                            showAIGame = true
                        } label: {
                            Image(.playAIIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceCool.shared.deviceType == .pad ?400:200)
                        }
                        
                        Button {
                            showPlayerGame = true
                        } label: {
                            Image(.playIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceCool.shared.deviceType == .pad ? 400:200)
                        }
                    }
                    
                    Spacer()
                    HStack {
                        Button {
                            showShop = true
                        } label: {
                            Image(.shopIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceCool.shared.deviceType == .pad ? 180:90)
                        }
                        Spacer()
                        Button {
                            showHowToPlay = true
                        } label: {
                            Image(.rulesIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceCool.shared.deviceType == .pad ? 180:90)
                        }
                        
                    }
                }.padding()
            }
            .background(
                ZStack {
                    Image(.menuBg)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
                
            )
            .onAppear {
                if settingsVM.musicEnabled {
                    MusicPlayer.shared.playBackgroundMusic()
                }
            }
            .onChange(of: settingsVM.musicEnabled) { enabled in
                if enabled {
                    MusicPlayer.shared.playBackgroundMusic()
                } else {
                    MusicPlayer.shared.stopBackgroundMusic()
                }
            }
            .fullScreenCover(isPresented: $showAIGame) {
                GameView(shopVM: shopVM, opponentState: .ai)
            }
            .fullScreenCover(isPresented: $showPlayerGame) {
                GameView(shopVM: shopVM, opponentState: .player)
            }
            .fullScreenCover(isPresented: $showHowToPlay) {
                RuleV()
            }
            .fullScreenCover(isPresented: $showShop) {
                ShopV(shopVM: shopVM)
                
            }
            .fullScreenCover(isPresented: $showSettings) {
                SV(settings: settingsVM)
                
            }
            
        }
        
        
    }
    
}

#Preview {
    MV()
}
