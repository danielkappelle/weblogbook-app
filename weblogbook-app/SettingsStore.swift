import Foundation

@Observable
class SettingsStore {
    var apiBaseURL: String {
        didSet { UserDefaults.standard.set(apiBaseURL, forKey: "apiBaseURL") }
    }

    var username: String {
        didSet { UserDefaults.standard.set(username, forKey: "username") }
    }

    var accessToken: String {
        didSet { KeychainHelper.save(accessToken, for: "accessToken") }
    }

    var isLoggedIn: Bool { !accessToken.isEmpty }

    init() {
        apiBaseURL  = UserDefaults.standard.string(forKey: "apiBaseURL") ?? ""
        username    = UserDefaults.standard.string(forKey: "username") ?? ""
        accessToken = KeychainHelper.load(for: "accessToken") ?? ""
    }

    func logout() {
        accessToken = ""
    }
}
