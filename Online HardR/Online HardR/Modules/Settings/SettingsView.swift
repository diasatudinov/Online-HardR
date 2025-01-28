import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsModel
    @ObservedObject var teamVM: TeamViewModel
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
                        
                        VStack(spacing: 8) {
                            
                            VStack(spacing: 0)  {
                                
                                Text("Sound")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 60:32))
                                
                                    Button {
                                        settings.musicEnabled.toggle()
                                    } label: {
                                        if settings.musicEnabled {
                                            Image(.on)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 50:26)
                                        } else {
                                            Image(.off)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 50:26)
                                        }
                                    }
                                    
                                    
                                
                            }
                            
                            VStack(spacing: 0)  {
                                
                                Text("Vibration")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 60 :32))
                                
                                    Button {
                                        settings.soundEnabled.toggle()
                                    } label: {
                                        if settings.soundEnabled {
                                            Image(.on)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 50:26)
                                        } else {
                                            Image(.off)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 50:26)
                                        }
                                    }
                                
                            }
                            
                            HStack {
                                Button {
                                    if let team = teamVM.currentTeam {
                                        nickname = team.name
                                        currentTeamIcon = team.icon
                                    }
                                    showChangeName = true
                                } label: {
                                    
                                    TextBg(height: DeviceInfo.shared.deviceType == .pad ? 85:46, text: "Change Name", textSize: DeviceInfo.shared.deviceType == .pad ? 40:20)
                                }
                                
                                Button {
                                    rateUs()
                                } label: {
                                    
                                    TextBg(height: DeviceInfo.shared.deviceType == .pad ? 85:46, text: "RATE US", textSize: DeviceInfo.shared.deviceType == .pad ? 40:20)
                                }
                            }
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
                                Image(.backBtn)
                                    .resizable()
                                    .scaledToFit()
                                
                            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                            
                        }
                        Spacer()
                    }.padding([.leading, .top])
                    Spacer()
                }
                
                if showChangeName {
                    ZStack {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        ZStack {
                            
                            
                            Image(.regBg)
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                Spacer()
                                Text("Name")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 70:36))
                                    .foregroundStyle(.white)
                                    .textCase(.uppercase)
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 60:30)
                                
                                ZStack {
                                    Image(.textFieldBg)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    
                                    TextField("Nickname", text: $nickname)
                                        .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 32:16))
                                        .bold()
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                    
                                    
                                }.padding(.horizontal, DeviceInfo.shared.deviceType == .pad ? 60:30)
                                
                                LazyVGrid(columns: columns, spacing: DeviceInfo.shared.deviceType == .pad ? 32:16) {
                                    ForEach(teamVM.teams.indices, id: \.self) { index in
                                        
                                        Button {
                                            currentTeamIcon = teamVM.teams[index].icon
                                        } label: {
                                            Image(teamVM.teams[index].icon)
                                                .resizable()
                                                .foregroundColor(.black)
                                                .scaledToFit()
                                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 39 * 1.8 : 39)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle()
                                                        .stroke(currentTeamIcon == teamVM.teams[index].icon ? Color.green : Color.clear, lineWidth: 4)
                                                )
                                        }
                                        
                                    }
                                }.padding(.bottom).padding(.horizontal, DeviceInfo.shared.deviceType == .pad ? 70:35)
                                
                                Spacer()
                            }
                        }.frame(width: DeviceInfo.shared.deviceType == .pad ? 400:213, height: DeviceInfo.shared.deviceType == .pad ? 500:250)
                        
                        VStack {
                            HStack {
                                Button {
                                    teamVM.updateCurrentTeam(name: nickname, icon: currentTeamIcon)
                                    showChangeName = false                                } label: {
                                        ZStack {
                                            Image(.backBtn)
                                                .resizable()
                                                .scaledToFit()
                                            
                                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                                        
                                    }
                                Spacer()
                            }.padding([.leading, .top])
                            Spacer()
                        }
                    }
                }
            }.background(
                ZStack {
                    Color.appSkyBlue
                    
                    Image(.bg1)
                        .resizable()
                        .scaledToFill()
                }.edgesIgnoringSafeArea(.all)
                
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
    SettingsView(settings: SettingsModel(), teamVM: TeamViewModel())
}
