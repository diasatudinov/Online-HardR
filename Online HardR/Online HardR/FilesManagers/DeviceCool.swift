//
//  DeviceInfo.swift
//  Online HardR
//
//  Created by Dias Atudinov on 28.01.2025.
//


import UIKit

class DeviceCool {
    static let shared = DeviceCool()
    
    var deviceType: UIUserInterfaceIdiom
    
    private init() {
        self.deviceType = UIDevice.current.userInterfaceIdiom
    }
}
