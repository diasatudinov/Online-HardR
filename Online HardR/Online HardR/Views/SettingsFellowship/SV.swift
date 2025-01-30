import SwiftUI
import StoreKit

struct SV: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SM
    @State private var showChangeName = false
    @State private var currentTeamIcon: String = ""
    @State private var nickname: String = ""

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack(spacing: 0)  {
                    Spacer()
                    ZStack {
                        
                        Image(.settingsBg)
                            .resizable()
                            .scaledToFit()
                        
                        VStack(spacing: 40) {
                            
                            VStack(spacing: 0)  {
                                HStack {
                                    Image(.sound)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceCool.shared.deviceType == .pad ? 140:90)
                                    
                                    Button {
                                        settings.musicEnabled = false
                                    } label: {
                                        Image(.minus)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: DeviceCool.shared.deviceType == .pad ? 80:40)
                                    }
                                    
                                    
                                        if settings.musicEnabled {
                                            Image(.on)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: DeviceCool.shared.deviceType == .pad ? 50:26)
                                        } else {
                                            Image(.off)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: DeviceCool.shared.deviceType == .pad ? 50:26)
                                        }
                                    Button {
                                        settings.musicEnabled = true
                                    } label: {
                                        Image(.plus)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: DeviceCool.shared.deviceType == .pad ? 80:40)
                                    }
                                }
                                    
                                
                            }
                            
                            VStack(spacing: 0)  {
                                HStack {
                                    Image(.music)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceCool.shared.deviceType == .pad ? 140:90)
                                    Button {
                                        settings.soundEnabled = false
                                    } label: {
                                        Image(.minus)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: DeviceCool.shared.deviceType == .pad ? 80:40)
                                    }
                                    
                                    if settings.soundEnabled {
                                        Image(.on)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: DeviceCool.shared.deviceType == .pad ? 50:26)
                                    } else {
                                        Image(.off)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: DeviceCool.shared.deviceType == .pad ? 50:26)
                                    }
                                    
                                    
                                    Button {
                                        settings.soundEnabled = true
                                    } label: {
                                        Image(.plus)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: DeviceCool.shared.deviceType == .pad ? 80:40)
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            Spacer()
                            Button {
                                rateUs()
                            } label: {
                                Image(.rateUs)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceCool.shared.deviceType == .pad ? 240:120)
                                    
                            }.offset(y: 30)
                            
                            
                        }
                    }.frame(height: geometry.size.height * 0.87)
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ZStack {
                                Image(.back)
                                    .resizable()
                                    .scaledToFit()
                                
                            }.frame(height: DeviceCool.shared.deviceType == .pad ? 100:50)
                            
                        }
                        Spacer()
                    }.padding([.leading, .top])
                    Spacer()
                }
                
               
            }.background(
                ZStack {
                    Color.purpleBg.ignoresSafeArea()
                    Image(.settingsLines)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                }
                
            )
        }
    }
    
    func rateUs() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    SV(settings: SM())
}
