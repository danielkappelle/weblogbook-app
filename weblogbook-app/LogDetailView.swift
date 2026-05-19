import SwiftUI

struct LogDetailView: View {
    let entry: LogEntry

    var body: some View {
        List {
            Section {
                HStack {
                    VStack {
                        Text(entry.departure.place)
                            .font(.largeTitle.bold())
                        Text(entry.departure.time)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.secondary)
                    Spacer()
                    VStack {
                        Text(entry.arrival.place)
                            .font(.largeTitle.bold())
                        Text(entry.arrival.time)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            Section("Flight") {
                LabeledContent("Date", value: entry.date.formatted(date: .long, time: .omitted))
                LabeledContent("PIC", value: entry.picName)
                if !entry.remarks.isEmpty {
                    LabeledContent("Remarks", value: entry.remarks)
                }
            }

            Section("Aircraft") {
                LabeledContent("Registration", value: entry.aircraft.registration)
                LabeledContent("Type", value: entry.aircraft.model)
            }

            Section("Flight time") {
                if !entry.flightTime.total.isEmpty      { LabeledContent("Total",         value: entry.flightTime.total) }
                if !entry.flightTime.pic.isEmpty        { LabeledContent("PIC",           value: entry.flightTime.pic) }
                if !entry.flightTime.coPilot.isEmpty    { LabeledContent("Co-pilot",      value: entry.flightTime.coPilot) }
                if !entry.flightTime.dual.isEmpty       { LabeledContent("Dual",          value: entry.flightTime.dual) }
                if !entry.flightTime.instructor.isEmpty { LabeledContent("Instructor",    value: entry.flightTime.instructor) }
                if !entry.flightTime.ifr.isEmpty        { LabeledContent("IFR",           value: entry.flightTime.ifr) }
                if !entry.flightTime.night.isEmpty      { LabeledContent("Night",         value: entry.flightTime.night) }
                if !entry.flightTime.mcc.isEmpty        { LabeledContent("MCC",           value: entry.flightTime.mcc) }
                if !entry.flightTime.singleEngine.isEmpty { LabeledContent("Single engine", value: entry.flightTime.singleEngine) }
                if !entry.flightTime.multiEngine.isEmpty  { LabeledContent("Multi engine",  value: entry.flightTime.multiEngine) }
            }

            Section("Landings") {
                LabeledContent("Day",   value: "\(entry.landings.day)")
                LabeledContent("Night", value: "\(entry.landings.night)")
            }

            if !entry.sim.type.isEmpty || !entry.sim.time.isEmpty {
                Section("Simulator") {
                    if !entry.sim.type.isEmpty { LabeledContent("Type", value: entry.sim.type) }
                    if !entry.sim.time.isEmpty { LabeledContent("Time", value: entry.sim.time) }
                }
            }
        }
        .navigationTitle(entry.date.formatted(.dateTime.day().month().year()))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LogDetailView(entry: LogEntry(
            id: UUID(),
            date: .now,
            departure: AirportEvent(place: "EHAM", time: "0800"),
            arrival: AirportEvent(place: "LFBD", time: "0900"),
            aircraft: Aircraft(model: "B738", registration: "PH-BXA"),
            flightTime: FlightTime(
                singleEngine: "", multiEngine: "", mcc: "2:00",
                total: "2:00", night: "", ifr: "2:00",
                pic: "", coPilot: "2:00", dual: "", instructor: "", crossCountry: "2:00"
            ),
            landings: Landings(day: 1, night: 0),
            sim: Simulator(type: "", time: ""),
            picName: "J Doe",
            remarks: "",
            distance: 500,
            recordNumber: 1,
            prevUUID: nil, nextUUID: nil,
            hasTrack: false,
            attachmentsCount: 0,
            tags: "", signature: ""
        ))
    }
}
