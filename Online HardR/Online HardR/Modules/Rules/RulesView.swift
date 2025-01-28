//
//  RulesView.swift
//  Online HardR
//
//  Created by Dias Atudinov on 28.01.2025.
//


import SwiftUI

struct RulesView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Image(.rulesBg)
                                .resizable()
                                .scaledToFit()
                            
                            Text("The goal of the game is to defeat your opponent by knocking out all of their pieces, with the last piece that must be knocked out being the one without a design. Players take turns moving their pieces across the board and knocking out the opponent's pieces. Each piece represents a musical element, such as an instrument or genre, except for one — the piece without a design, which is key to winning. The game ends when all of the opponent's pieces are knocked out, and the last piece to be knocked out must be the one without a design.")
                                .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 24:13, weight: .bold))
                                .foregroundColor(.darkPurple)
                                .multilineTextAlignment(.center)
                                .textCase(.uppercase)
                                .frame(width: DeviceInfo.shared.deviceType == .pad ? 600:330)
                                .padding(.top, 60)
                            
                        }.frame(height: geometry.size.height * 0.87)
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(.back)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding(20)
                
            }.background(
                Image(.menuBg)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            )
        }
    }
}

#Preview {
    RulesView()
}
