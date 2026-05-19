//
//  ContentView.swift
//  weblogbook-app
//
//  Created by Daniel Kappelle on 19/05/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack(alignment: .leading) {
            switch appState.selectedSection {
            case .logs:     LogsView()
            case .settings: SettingsView()
            }

            if appState.isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            appState.isMenuOpen = false
                        }
                    }

                SideMenuView()
                    .transition(.move(edge: .leading))
            }
        }
    }
}

#Preview {
    ContentView().environment(AppState())
}
