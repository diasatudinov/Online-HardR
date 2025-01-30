import SwiftUI

class SM: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}
