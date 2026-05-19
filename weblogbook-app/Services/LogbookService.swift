import Foundation

enum LogbookServiceError: Error, LocalizedError {
    case invalidResponse(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse(let code): "Unexpected response from server (HTTP \(code))"
        }
    }
}

struct LogbookService {
    func fetchLogs() async throws -> [LogEntry] {
        let url = AppConfig.apiBaseURL.appendingPathComponent("logbook/data")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AppConfig.apiKey)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw LogbookServiceError.invalidResponse(statusCode: code)
        }

        let dtos = try JSONDecoder().decode([LogEntryDTO].self, from: data)
        return dtos.compactMap { $0.toDomain() }
    }
}
