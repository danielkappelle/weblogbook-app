import SwiftUI

struct LogDetailView: View {
    let entry: LogEntry

    var body: some View {
        List {
            Section {
                HStack {
                    Text(entry.departureAirport)
                        .font(.largeTitle.bold())
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(entry.destinationAirport)
                        .font(.largeTitle.bold())
                }
                .padding(.vertical, 8)
            }

            Section("Flight") {
                LabeledContent("Date", value: entry.date.formatted(date: .long, time: .omitted))
                LabeledContent("Block time", value: entry.blockTime.formatted(.time(pattern: .hourMinute)))
            }

            Section("Aircraft") {
                LabeledContent("Registration", value: entry.aircraftRegistration)
            }
        }
        .navigationTitle(entry.date.formatted(.dateTime.day().month().year()))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LogDetailView(entry: LogEntry(
            date: .now,
            departureAirport: "EHAM",
            destinationAirport: "EGLL",
            blockTime: .seconds(7320),
            aircraftRegistration: "PH-BXA"
        ))
    }
}
