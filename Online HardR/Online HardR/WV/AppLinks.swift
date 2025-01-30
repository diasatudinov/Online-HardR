//
//  AppLinks.swift
//  Online HardR
//
//  Created by Dias Atudinov on 30.01.2025.
//


import SwiftUI

class AppLinks {
    
    static let shared = AppLinks()
    
    static let winStarData = "https://7fthrs.fun/app"
    //"?page=test"
    
    @AppStorage("finalUrl") var finalURL: URL?
    
    
}
