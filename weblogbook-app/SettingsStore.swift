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

    var requiresAuth: Bool {
        didSet { UserDefaults.standard.set(requiresAuth, forKey: "requiresAuth") }
    }

    var isConnected: Bool {
        didSet { UserDefaults.standard.set(isConnected, forKey: "isConnected") }
    }

    var apiVersion: String {
        didSet { UserDefaults.standard.set(apiVersion, forKey: "apiVersion") }
    }

    var ownerName: String {
        didSet { UserDefaults.standard.set(ownerName, forKey: "ownerName") }
    }

    var licenseNumber: String {
        didSet { UserDefaults.standard.set(licenseNumber, forKey: "licenseNumber") }
    }

    init() {
        apiBaseURL    = UserDefaults.standard.string(forKey: "apiBaseURL") ?? ""
        username      = UserDefaults.standard.string(forKey: "username") ?? ""
        accessToken   = KeychainHelper.load(for: "accessToken") ?? ""
        requiresAuth  = UserDefaults.standard.object(forKey: "requiresAuth") as? Bool ?? true
        isConnected   = UserDefaults.standard.bool(forKey: "isConnected")
        apiVersion    = UserDefaults.standard.string(forKey: "apiVersion") ?? ""
        ownerName     = UserDefaults.standard.string(forKey: "ownerName") ?? ""
        licenseNumber = UserDefaults.standard.string(forKey: "licenseNumber") ?? ""
    }

    func disconnect() {
        accessToken   = ""
        isConnected   = false
        apiVersion    = ""
        ownerName     = ""
        licenseNumber = ""
    }
}
