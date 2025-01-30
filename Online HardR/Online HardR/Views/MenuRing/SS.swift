//
//  SplashScreen.swift
//  Online HardR
//
//  Created by Dias Atudinov on 28.01.2025.
//

import SwiftUI

struct SS: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                }
                Spacer()
                ZStack {
                    VStack {
                        Text("Loading...")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.neon)
                            .textCase(.uppercase)
                        ProgressView(value: progress, total: 100)
                            .progressViewStyle(LinearProgressViewStyle())
                            .accentColor(Color.mainPurple)
                            .cornerRadius(10)
                            .padding(.horizontal, 1)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.darkPurple, lineWidth: 1)
                            }
                            .scaleEffect(y: 4.0, anchor: .center)
                            .padding(.horizontal, 92)
                    }
                }
                .foregroundColor(.black)
                .padding(.bottom, 25)
            }
        }.background(
            Image(.splashBg)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                
        )
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 100 {
                progress += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    SS()
}

struct TextWithBorder: View {
    let text: String
    let font: Font
    let textColor: Color
    let borderColor: Color
    let borderWidth: CGFloat

    var body: some View {
        ZStack {
            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .glowBorder(color: borderColor, lineWidth: 5)
            
            
        }
    }
}

struct GlowBorder: ViewModifier {
    var color: Color
    var lineWidth: Int
    func body(content: Content) -> some View {
        applyShadow(content: AnyView(content), lineWidth: lineWidth)
    }
    
    func applyShadow(content: AnyView, lineWidth: Int) -> AnyView {
        if lineWidth == 0 {
            return content
        } else {
            return applyShadow(content: AnyView(content.shadow(color: color, radius: 1)), lineWidth: lineWidth - 1)
        }
    }
}

extension View {
    func glowBorder(color: Color, lineWidth: Int) -> some View {
        self.modifier(GlowBorder(color: color, lineWidth: lineWidth))
    }
}
