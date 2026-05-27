import Foundation

struct Person: Identifiable {
    let id: UUID
    let firstName: String
    let middleName: String
    let lastName: String
    let phone: String
    let email: String
    let remarks: String

    var fullName: String {
        [firstName, middleName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
    }
}

struct PersonDTO: Decodable {
    let uuid: String
    let firstName: String
    let middleName: String
    let lastName: String
    let phone: String
    let email: String
    let remarks: String

    enum CodingKeys: String, CodingKey {
        case uuid, phone, email, remarks
        case firstName  = "first_name"
        case middleName = "middle_name"
        case lastName   = "last_name"
    }

    func toDomain() -> Person? {
        guard let id = UUID(uuidString: uuid) else { return nil }
        return Person(id: id, firstName: firstName, middleName: middleName,
                      lastName: lastName, phone: phone, email: email, remarks: remarks)
    }
}

struct FlightPerson: Identifiable {
    let id: UUID
    let fullName: String
    let role: String
}

struct FlightPersonDTO: Decodable {
    let uuid: String
    let firstName: String
    let middleName: String
    let lastName: String
    let role: String

    enum CodingKeys: String, CodingKey {
        case uuid, role
        case firstName  = "first_name"
        case middleName = "middle_name"
        case lastName   = "last_name"
    }

    func toDomain() -> FlightPerson? {
        guard let id = UUID(uuidString: uuid) else { return nil }
        let name = [firstName, middleName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
        return FlightPerson(id: id, fullName: name, role: role)
    }
}
