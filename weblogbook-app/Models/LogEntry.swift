import Foundation

struct LogEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let departure: AirportEvent
    let arrival: AirportEvent
    let aircraft: Aircraft
    let flightTime: FlightTime
    let landings: Landings
    let sim: Simulator
    let picName: String
    let remarks: String
    let distance: Double?
    let recordNumber: Int
    let prevUUID: UUID?
    let nextUUID: UUID?
    let hasTrack: Bool
    let attachmentsCount: Int
    let tags: String
    let signature: String
}

struct AirportEvent: Codable, Hashable {
    let place: String
    let time: String  // "HHmm" format, e.g. "0727"
}

struct Aircraft: Codable, Hashable {
    let model: String
    let registration: String
}

struct FlightTime: Codable, Hashable {
    let singleEngine: String
    let multiEngine: String
    let mcc: String
    let total: String
    let night: String
    let ifr: String
    let pic: String
    let coPilot: String
    let dual: String
    let instructor: String
    let crossCountry: String
}

struct Landings: Codable, Hashable {
    let day: Int
    let night: Int
}

struct Simulator: Codable, Hashable {
    let type: String
    let time: String
}
