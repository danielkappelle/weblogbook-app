import SwiftUI

private func makeEntry(
    uuid: String, daysAgo: Double,
    dep: String, depTime: String,
    arr: String, arrTime: String,
    model: String, reg: String,
    total: String, ifr: String, coPilot: String, mcc: String,
    distance: Double, recordNumber: Int,
    picName: String = "J Doe"
) -> LogEntry {
    LogEntry(
        id: UUID(uuidString: uuid)!,
        date: .now - daysAgo * 86400,
        departure: AirportEvent(place: dep, time: depTime),
        arrival: AirportEvent(place: arr, time: arrTime),
        aircraft: Aircraft(model: model, registration: reg),
        flightTime: FlightTime(
            singleEngine: "", multiEngine: "", mcc: mcc,
            total: total, night: "", ifr: ifr,
            pic: "", coPilot: coPilot, dual: "", instructor: "", crossCountry: total
        ),
        landings: Landings(day: 1, night: 0),
        sim: Simulator(type: "", time: ""),
        picName: picName,
        remarks: "",
        distance: distance,
        recordNumber: recordNumber,
        prevUUID: nil, nextUUID: nil,
        hasTrack: false,
        attachmentsCount: 0,
        tags: "", signature: ""
    )
}

private let dummyLogs: [LogEntry] = [
    makeEntry(uuid: "f908ea9a-5baf-4c13-96cb-141b96be7820", daysAgo: 0,  dep: "EHAM", depTime: "0727", arr: "LFBD", arrTime: "0858", model: "B738", reg: "PH-BCB", total: "1:31", ifr: "1:31", coPilot: "1:31", mcc: "1:31", distance: 499,  recordNumber: 439),
    makeEntry(uuid: "85fc3edc-f5b1-4253-8040-5d79a695ceeb", daysAgo: 2,  dep: "LFBD", depTime: "1015", arr: "EHAM", arrTime: "1148", model: "B738", reg: "PH-BCB", total: "1:33", ifr: "1:33", coPilot: "1:33", mcc: "1:33", distance: 499,  recordNumber: 438),
    makeEntry(uuid: "a1b2c3d4-0000-0000-0000-000000000001", daysAgo: 5,  dep: "EHAM", depTime: "0600", arr: "EDDM", arrTime: "0730", model: "B738", reg: "PH-BXB", total: "1:30", ifr: "1:30", coPilot: "1:30", mcc: "1:30", distance: 622,  recordNumber: 437),
    makeEntry(uuid: "a1b2c3d4-0000-0000-0000-000000000002", daysAgo: 8,  dep: "EDDM", depTime: "1100", arr: "LEBL", arrTime: "1312", model: "B738", reg: "PH-BXB", total: "2:12", ifr: "2:12", coPilot: "2:12", mcc: "2:12", distance: 1095, recordNumber: 436),
    makeEntry(uuid: "a1b2c3d4-0000-0000-0000-000000000003", daysAgo: 12, dep: "LEBL", depTime: "0830", arr: "EHAM", arrTime: "1105", model: "B738", reg: "PH-BXA", total: "2:35", ifr: "2:35", coPilot: "2:35", mcc: "2:35", distance: 1467, recordNumber: 435),
]

struct LogsView: View {
    var body: some View {
        NavigationStack {
            List(dummyLogs) { entry in
                NavigationLink(destination: LogDetailView(entry: entry)) {
                    LogEntryCard(entry: entry)
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
