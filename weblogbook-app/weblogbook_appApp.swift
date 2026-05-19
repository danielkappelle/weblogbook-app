//
//  weblogbook_appApp.swift
//  weblogbook-app
//
//  Created by Daniel Kappelle on 19/05/2026.
//

import SwiftUI

@main
struct weblogbook_appApp: App {
    @State private var appState = AppState()
    @State private var settingsStore = SettingsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(settingsStore)
        }
    }
}
