import SwiftUI

@main
struct TherapAIApp: App {
    @State private var showSplashScreen = true

    init() {
        setupUserID()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if showSplashScreen {
                    SplashScreenView {
                        withAnimation {
                            self.showSplashScreen = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
    }

    func setupUserID() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "userUUIDHash") == nil {
            let uuid = UUID()
            let uniqueIntID = uuid.uuidString.hashValue
            userDefaults.set(uniqueIntID, forKey: "userUUIDHash")
        }
    }
}
