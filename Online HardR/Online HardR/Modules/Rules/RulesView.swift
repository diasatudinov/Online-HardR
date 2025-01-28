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
                            
                            Text("The game features tiles numbered from 1 to 7 and two empty spaces. The goal is to arrange the numbers in ascending order, starting from the top-left corner. Players can move the tiles by sliding them into either of the two empty spaces. The objective is to complete the arrangement in the fewest moves or the shortest time. The two empty spaces add a strategic element, enabling more complex combinations. The game can be competitive, with players racing to finish first, or single-player, focusing on move or time optimization. The game ends when all numbers are in the correct sequence")
                                .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 24:12))
                                .multilineTextAlignment(.center)
                                .textCase(.uppercase)
                                .frame(width: DeviceInfo.shared.deviceType == .pad ? 600:330)
                                .padding(.top, 20)
                            
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
                            Image(.backBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding(20)
                
            }
            .background(
                ZStack {
                    Color.appSkyBlue
                    
                    Image(.bg1)
                        .resizable()
                        .scaledToFill()
                }.edgesIgnoringSafeArea(.all)
                
            )
        }
    }
}

#Preview {
    RulesView()
}
