import Foundation

struct NewPersonRequest: Encodable {
    let uuid       = "new"
    let isNew      = true
    let firstName: String
    let middleName: String
    let lastName: String
    let phone: String
    let email: String
    let remarks: String

    enum CodingKeys: String, CodingKey {
        case uuid, isNew, phone, email, remarks
        case firstName  = "first_name"
        case middleName = "middle_name"
        case lastName   = "last_name"
    }
}
