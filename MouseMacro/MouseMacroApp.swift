import SwiftUI
import Cocoa

@main
struct MouseMacroAppSwiftUI: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
