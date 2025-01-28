//
//  SettingsModel.swift
//  Online HardR
//
//  Created by Dias Atudinov on 28.01.2025.
//


import SwiftUI

class SettingsModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}