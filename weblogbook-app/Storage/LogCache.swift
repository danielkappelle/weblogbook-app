import Foundation

enum LogCache {
    private static let cacheURL: URL? = FileManager.default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent("logs.json")

    static func save(_ logs: [LogEntry]) {
        guard let url = cacheURL,
              let data = try? JSONEncoder().encode(logs) else { return }
        try? data.write(to: url, options: .atomic)
    }

    static func load() -> [LogEntry]? {
        guard let url = cacheURL,
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([LogEntry].self, from: data)
    }
}
