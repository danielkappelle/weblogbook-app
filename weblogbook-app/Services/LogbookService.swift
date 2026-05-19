import Foundation

enum LogbookServiceError: Error, LocalizedError {
    case invalidConfiguration
    case invalidResponse(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:           "API URL is not configured. Please set it in Settings."
        case .invalidResponse(let code):      "Unexpected response from server (HTTP \(code))"
        }
    }
}

struct LogbookService {
    let settings: SettingsStore

    func fetchLogs() async throws -> [LogEntry] {
        guard !settings.apiBaseURL.isEmpty,
              let base = URL(string: settings.apiBaseURL) else {
            throw LogbookServiceError.invalidConfiguration
        }

        let url = base.appendingPathComponent("logbook/data")
        var request = URLRequest(url: url)
        if !settings.accessToken.isEmpty {
            request.setValue("Bearer \(settings.accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw LogbookServiceError.invalidResponse(statusCode: code)
        }

        let dtos = try JSONDecoder().decode([LogEntryDTO].self, from: data)
        return dtos.compactMap { $0.toDomain() }
    }
}
