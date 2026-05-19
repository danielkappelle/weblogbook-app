import Foundation

@Observable
class SettingsStore {
    var apiBaseURL: String {
        didSet { UserDefaults.standard.set(apiBaseURL, forKey: "apiBaseURL") }
    }

    var accessToken: String {
        didSet { KeychainHelper.save(accessToken, for: "accessToken") }
    }

    init() {
        apiBaseURL    = UserDefaults.standard.string(forKey: "apiBaseURL") ?? ""
        accessToken   = KeychainHelper.load(for: "accessToken") ?? ""
    }
}
