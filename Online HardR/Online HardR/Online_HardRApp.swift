import SwiftUI

@main
struct Online_HardRApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RV()
        }
    }
}
