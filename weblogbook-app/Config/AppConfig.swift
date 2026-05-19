import Foundation

enum AppConfig {
    static let apiBaseURL: URL = {
        guard let string = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
              !string.isEmpty,
              let url = URL(string: string) else {
            fatalError("API_BASE_URL is missing or invalid in Info.plist")
        }
        return url
    }()

    static let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
              !key.isEmpty else {
            fatalError("API_KEY is missing in Info.plist")
        }
        return key
    }()
}
