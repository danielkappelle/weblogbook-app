import SwiftUI

struct LogEntryCard: View {
    let entry: LogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(entry.aircraft.registration)
                    .font(.subheadline.bold())
            }

            HStack(spacing: 8) {
                Text(entry.departure.place)
                    .font(.title2.bold())
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                Text(entry.arrival.place)
                    .font(.title2.bold())
                Spacer()
                Label(entry.flightTime.total, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    LogEntryCard(entry: LogEntry(
        id: UUID(),
        date: .now,
        departure: AirportEvent(place: "EHAM", time: "0727"),
        arrival: AirportEvent(place: "EGLL", time: "0858"),
        aircraft: Aircraft(model: "B738", registration: "PH-BXA"),
        flightTime: FlightTime(
            singleEngine: "", multiEngine: "", mcc: "1:31",
            total: "1:31", night: "", ifr: "1:31",
            pic: "", coPilot: "1:31", dual: "", instructor: "", crossCountry: "1:31"
        ),
        landings: Landings(day: 1, night: 0),
        sim: Simulator(type: "", time: ""),
        picName: "S Kok",
        remarks: "",
        distance: 499,
        recordNumber: 439,
        prevUUID: nil, nextUUID: nil,
        hasTrack: false,
        attachmentsCount: 0,
        tags: "", signature: ""
    ))
    .padding()
}
