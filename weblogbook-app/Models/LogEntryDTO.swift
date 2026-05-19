import Foundation

struct LogEntryDTO: Decodable {
    let uuid: String
    let date: String
    let departure: AirportEventDTO
    let arrival: AirportEventDTO
    let aircraft: AircraftDTO
    let time: FlightTimeDTO
    let landings: LandingsDTO
    let sim: SimulatorDTO
    let picName: String
    let remarks: String
    let distance: Double?
    let recordNumber: Int
    let prevUuid: String
    let nextUuid: String
    let hasTrack: Int
    let attachmentsCount: Int
    let tags: String
    let signature: String

    enum CodingKeys: String, CodingKey {
        case uuid, date, departure, arrival, aircraft, time, landings, sim, remarks, distance, tags, signature
        case picName = "pic_name"
        case recordNumber = "record_number"
        case prevUuid = "prev_uuid"
        case nextUuid = "next_uuid"
        case hasTrack = "has_track"
        case attachmentsCount = "attachments_count"
    }
}

struct AirportEventDTO: Decodable {
    let place: String
    let time: String
}

struct AircraftDTO: Decodable {
    let model: String
    let regName: String

    enum CodingKeys: String, CodingKey {
        case model
        case regName = "reg_name"
    }
}

struct FlightTimeDTO: Decodable {
    let seTime: String
    let meTime: String
    let mccTime: String
    let totalTime: String
    let nightTime: String
    let ifrTime: String
    let picTime: String
    let coPilotTime: String
    let dualTime: String
    let instructorTime: String
    let ccTime: String

    enum CodingKeys: String, CodingKey {
        case seTime = "se_time"
        case meTime = "me_time"
        case mccTime = "mcc_time"
        case totalTime = "total_time"
        case nightTime = "night_time"
        case ifrTime = "ifr_time"
        case picTime = "pic_time"
        case coPilotTime = "co_pilot_time"
        case dualTime = "dual_time"
        case instructorTime = "instructor_time"
        case ccTime = "cc_time"
    }
}

struct LandingsDTO: Decodable {
    let day: Int
    let night: Int
}

struct SimulatorDTO: Decodable {
    let type: String
    let time: String
}

// MARK: - Mapping to domain model

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "dd/MM/yyyy"
    f.locale = Locale(identifier: "en_US_POSIX")
    return f
}()

extension LogEntryDTO {
    func toDomain() -> LogEntry? {
        guard let date = dateFormatter.date(from: self.date) else { return nil }

        return LogEntry(
            id: UUID(uuidString: uuid) ?? UUID(),
            date: date,
            departure: AirportEvent(place: departure.place, time: departure.time),
            arrival: AirportEvent(place: arrival.place, time: arrival.time),
            aircraft: Aircraft(model: aircraft.model, registration: aircraft.regName),
            flightTime: FlightTime(
                singleEngine: time.seTime,
                multiEngine: time.meTime,
                mcc: time.mccTime,
                total: time.totalTime,
                night: time.nightTime,
                ifr: time.ifrTime,
                pic: time.picTime,
                coPilot: time.coPilotTime,
                dual: time.dualTime,
                instructor: time.instructorTime,
                crossCountry: time.ccTime
            ),
            landings: Landings(day: landings.day, night: landings.night),
            sim: Simulator(type: sim.type, time: sim.time),
            picName: picName,
            remarks: remarks,
            distance: distance,
            recordNumber: recordNumber,
            prevUUID: UUID(uuidString: prevUuid),
            nextUUID: UUID(uuidString: nextUuid),
            hasTrack: hasTrack != 0,
            attachmentsCount: attachmentsCount,
            tags: tags,
            signature: signature
        )
    }
}
