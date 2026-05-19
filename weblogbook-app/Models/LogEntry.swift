import Foundation

struct LogEntry: Identifiable {
    let id = UUID()
    let date: Date
    let departureAirport: String
    let destinationAirport: String
    let blockTime: Duration
    let aircraftRegistration: String
}
