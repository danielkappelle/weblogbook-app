import SwiftUI

private let dummyLogs: [LogEntry] = [
    LogEntry(date: .now,                          departureAirport: "EHAM", destinationAirport: "EGLL", blockTime: .seconds(7320),  aircraftRegistration: "PH-BXA"),
    LogEntry(date: .now - 86400,                  departureAirport: "EGLL", destinationAirport: "EHAM", blockTime: .seconds(6900),  aircraftRegistration: "PH-BXA"),
    LogEntry(date: .now - 86400 * 3,              departureAirport: "EHAM", destinationAirport: "EDDM", blockTime: .seconds(5400),  aircraftRegistration: "PH-BXB"),
    LogEntry(date: .now - 86400 * 5,              departureAirport: "EDDM", destinationAirport: "LEBL", blockTime: .seconds(8100),  aircraftRegistration: "PH-BXB"),
    LogEntry(date: .now - 86400 * 7,              departureAirport: "LEBL", destinationAirport: "EHAM", blockTime: .seconds(9000),  aircraftRegistration: "PH-BXA"),
]

struct LogsView: View {
    var body: some View {
        NavigationStack {
            List(dummyLogs) { entry in
                NavigationLink(destination: LogDetailView(entry: entry)) {
                    LogEntryCard(
                        date: entry.date,
                        departureAirport: entry.departureAirport,
                        destinationAirport: entry.destinationAirport,
                        blockTime: entry.blockTime,
                        aircraftRegistration: entry.aircraftRegistration
                    )
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            }
            .listStyle(.plain)
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    LogsView()
}
