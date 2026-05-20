import Foundation

struct NewLogRequest: Encodable {
    let uuid = "new"
    let date: String
    let departure: NewLogAirportEvent
    let arrival: NewLogAirportEvent
    let aircraft: NewLogAircraft
    let time: NewLogFlightTime
    let landings: NewLogLandings
    let sim: NewLogSimulator
    let picName: String
    let remarks: String
    let redraw: Double = Double.random(in: 0...1)
    let customFields = "{}"

    enum CodingKeys: String, CodingKey {
        case uuid, date, departure, arrival, aircraft, time, landings, sim, remarks, redraw
        case picName      = "pic_name"
        case customFields = "custom_fields"
    }
}

struct NewLogAirportEvent: Encodable {
    let place: String
    let time: String
}

struct NewLogAircraft: Encodable {
    let model: String
    let regName: String

    enum CodingKeys: String, CodingKey {
        case model
        case regName = "reg_name"
    }
}

struct NewLogFlightTime: Encodable {
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

    enum CodingKeys: String, CodingKey {
        case seTime        = "se_time"
        case meTime        = "me_time"
        case mccTime       = "mcc_time"
        case totalTime     = "total_time"
        case nightTime     = "night_time"
        case ifrTime       = "ifr_time"
        case picTime       = "pic_time"
        case coPilotTime   = "co_pilot_time"
        case dualTime      = "dual_time"
        case instructorTime = "instructor_time"
    }
}

struct NewLogLandings: Encodable {
    let day: Int
    let night: Int
}

struct NewLogSimulator: Encodable {
    let type: String
    let time: String
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "dd/MM/yyyy"
    f.locale = Locale(identifier: "en_US_POSIX")
    return f
}()

extension NewLogRequest {
    init(
        date: Date,
        departurePlace: String, departureTime: String,
        arrivalPlace: String,   arrivalTime: String,
        aircraftModel: String,  aircraftReg: String,
        totalTime: String, seTime: String, meTime: String, mccTime: String,
        nightTime: String, ifrTime: String, picTime: String,
        coPilotTime: String, dualTime: String, instructorTime: String,
        landingsDay: Int, landingsNight: Int,
        simType: String, simTime: String,
        picName: String, remarks: String
    ) {
        self.date       = dateFormatter.string(from: date)
        self.departure  = NewLogAirportEvent(place: departurePlace, time: departureTime)
        self.arrival    = NewLogAirportEvent(place: arrivalPlace,   time: arrivalTime)
        self.aircraft   = NewLogAircraft(model: aircraftModel, regName: aircraftReg)
        self.time       = NewLogFlightTime(
            seTime: seTime, meTime: meTime, mccTime: mccTime,
            totalTime: totalTime, nightTime: nightTime, ifrTime: ifrTime,
            picTime: picTime, coPilotTime: coPilotTime,
            dualTime: dualTime, instructorTime: instructorTime
        )
        self.landings   = NewLogLandings(day: landingsDay, night: landingsNight)
        self.sim        = NewLogSimulator(type: simType, time: simTime)
        self.picName    = picName
        self.remarks    = remarks
    }
}
