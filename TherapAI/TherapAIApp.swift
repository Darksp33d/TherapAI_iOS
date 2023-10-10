//
//  TherapAIApp.swift
//  TherapAI
//
//  Created by Iman Shalizi on 10/8/23.
//

import SwiftUI

@main
struct TherapAIApp: App {
    init() {
        setupUserID()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()  // or whatever your main content view is named
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
