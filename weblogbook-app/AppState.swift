import SwiftUI

enum AppSection: CaseIterable {
    case logs
    case persons
    case settings

    var title: String {
        switch self {
        case .logs:     "Logs"
        case .persons:  "Persons"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .logs:     "book"
        case .persons:  "person.2"
        case .settings: "gear"
        }
    }
}

@Observable
class AppState {
    var isMenuOpen = false
    var selectedSection: AppSection = .logs
}
