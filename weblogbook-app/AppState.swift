import SwiftUI

enum AppSection: CaseIterable {
    case logs
    case settings

    var title: String {
        switch self {
        case .logs:     "Logs"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .logs:     "book"
        case .settings: "gear"
        }
    }
}

@Observable
class AppState {
    var isMenuOpen = false
    var selectedSection: AppSection = .logs
}
