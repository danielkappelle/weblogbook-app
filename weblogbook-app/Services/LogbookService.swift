import Foundation

enum LogbookServiceError: Error, LocalizedError {
    case invalidConfiguration
    case invalidCredentials
    case notAuthenticated
    case offline
    case invalidResponse(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:       "API URL is not configured. Please set it in Settings."
        case .invalidCredentials:         "Invalid username or password."
        case .notAuthenticated:           "Not authenticated"
        case .offline:                    "Device is offline"
        case .invalidResponse(let code):  "Unexpected response from server (HTTP \(code))"
        }
    }
}

struct LogbookService {
    let settings: SettingsStore

    private var baseURL: URL {
        get throws {
            guard !settings.apiBaseURL.isEmpty,
                  let url = URL(string: settings.apiBaseURL) else {
                throw LogbookServiceError.invalidConfiguration
            }
            return url
        }
    }

    func login(username: String, password: String) async throws -> String {
        let url = try baseURL.appendingPathComponent("login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["login": username, "password": password])

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw LogbookServiceError.offline
        } catch {
            throw error
        }
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1

        if code == 403 { throw LogbookServiceError.invalidCredentials }
        guard code == 200 else { throw LogbookServiceError.invalidResponse(statusCode: code) }

        return try JSONDecoder().decode(LoginResponse.self, from: data).token
    }

    func createLog(_ log: NewLogRequest) async throws -> String {
        let url = try baseURL.appendingPathComponent("logbook/new")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !settings.accessToken.isEmpty {
            request.setValue("Bearer \(settings.accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(log)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw LogbookServiceError.offline
        } catch {
            throw error
        }

        let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        if code == 401 { throw LogbookServiceError.notAuthenticated }
        guard code == 200 else { throw LogbookServiceError.invalidResponse(statusCode: code) }

        return (try? JSONDecoder().decode(CreateLogResponse.self, from: data))?.data ?? ""
    }

    func fetchVersion() async throws -> String {
        let url = try baseURL.appendingPathComponent("version")
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw LogbookServiceError.offline
        } catch {
            throw error
        }
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard code == 200 else { throw LogbookServiceError.invalidResponse(statusCode: code) }
        return String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"")) ?? ""
    }

    func fetchServerSettings() async throws -> ServerSettings {
        let url = try baseURL.appendingPathComponent("settings/list")
        var request = URLRequest(url: url)
        if !settings.accessToken.isEmpty {
            request.setValue("Bearer \(settings.accessToken)", forHTTPHeaderField: "Authorization")
        }
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw LogbookServiceError.offline
        } catch {
            throw error
        }
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        if code == 401 { throw LogbookServiceError.notAuthenticated }
        guard code == 200 else { throw LogbookServiceError.invalidResponse(statusCode: code) }
        let dto = try JSONDecoder().decode(ServerSettingsDTO.self, from: data)
        return ServerSettings(ownerName: dto.ownerName, licenseNumber: dto.licenseNumber)
    }

    func fetchLogs() async throws -> [LogEntry] {
        let url = try baseURL.appendingPathComponent("logbook/data")
        var request = URLRequest(url: url)
        if !settings.accessToken.isEmpty {
            request.setValue("Bearer \(settings.accessToken)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw LogbookServiceError.offline
        } catch {
            throw error
        }
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1

        if code == 401 { throw LogbookServiceError.notAuthenticated }
        guard code == 200 else { throw LogbookServiceError.invalidResponse(statusCode: code)}


        let dtos = try JSONDecoder().decode([LogEntryDTO].self, from: data)
        return dtos.compactMap { $0.toDomain() }
    }

    func fetchPersons() async throws -> [Person] {
        let url = try baseURL.appendingPathComponent("person/list")
        var request = URLRequest(url: url)
        if !settings.accessToken.isEmpty {
            request.setValue("Bearer \(settings.accessToken)", forHTTPHeaderField: "Authorization")
        }
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw LogbookServiceError.offline
        } catch {
            throw error
        }
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        if code == 401 { throw LogbookServiceError.notAuthenticated }
        guard code == 200 else { throw LogbookServiceError.invalidResponse(statusCode: code) }
        return try JSONDecoder().decode([PersonDTO].self, from: data).compactMap { $0.toDomain() }
    }
}

struct ServerSettings {
    let ownerName: String
    let licenseNumber: String
}

private struct ServerSettingsDTO: Decodable {
    let ownerName: String
    let licenseNumber: String
    enum CodingKeys: String, CodingKey {
        case ownerName     = "owner_name"
        case licenseNumber = "license_number"
    }
}

private struct LoginResponse: Decodable {
    let token: String
}

private struct CreateLogResponse: Decodable {
    let data: String
}
