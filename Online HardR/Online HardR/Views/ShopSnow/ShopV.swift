//
//  ShopView.swift
//  Online HardR
//
//  Created by Dias Atudinov on 28.01.2025.
//

import SwiftUI

struct ShopV: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var shopVM: SVM

    var body: some View {
        ZStack {
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
                
                HStack(spacing: 20) {
                    ForEach(shopVM.shopItems, id: \.self) { item in
                        Button {
                            shopVM.currentItem = item
                        } label: {
                        ZStack {
                            Image(.shopItemBg)
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                Text(item.name)
                                    .font(.system(size: DeviceCool.shared.deviceType == .pad ? 24:20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 120)
                                ZStack {
                                    if item.name == "Creators of beauty" {
                                        Image(.itemIcon2)
                                            .resizable()
                                            .scaledToFit()
                                        
                                        
                                    } else if item.name == "Musical heaven" {
                                        Image(.itemIcon1)
                                            .resizable()
                                            .scaledToFit()
                                        
                                    } else if item.name == "World classic" {
                                        Image(.itemIcon3)
                                            .resizable()
                                            .scaledToFit()
                                        
                                    }
                                    if let currentItem = shopVM.currentItem, currentItem.name == item.name {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image(.tick)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height:DeviceCool.shared.deviceType == .pad ? 100:50)
                                            }.frame(width: DeviceCool.shared.deviceType == .pad ? 300:150)
                                        }
                                    }
                                }.frame(height: DeviceCool.shared.deviceType == .pad ? 300:150)
                                Spacer()
                            }//.padding()
                        }
                            
                            
                        }.frame(height: DeviceCool.shared.deviceType == .pad ? 550:290)
                    }
                }
                
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

#Preview {
    ShopV(shopVM: SVM())
}
