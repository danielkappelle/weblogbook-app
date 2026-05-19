import SwiftUI

struct LogEntryCard: View {
    let date: Date
    let departureAirport: String
    let destinationAirport: String
    let blockTime: Duration
    let aircraftRegistration: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(aircraftRegistration)
                    .font(.subheadline.bold())
            }

            HStack(spacing: 8) {
                Text(departureAirport)
                    .font(.title2.bold())
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                Text(destinationAirport)
                    .font(.title2.bold())
                Spacer()
                Label(blockTime.formatted(.time(pattern: .hourMinute)), systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    LogEntryCard(
        date: .now,
        departureAirport: "EHAM",
        destinationAirport: "EGLL",
        blockTime: .seconds(7320),
        aircraftRegistration: "PH-BXA"
    )
    .padding()
}
