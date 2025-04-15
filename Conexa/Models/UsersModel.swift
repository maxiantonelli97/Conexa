import Foundation

struct UsersModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let address: AddressModel
}

struct AddressModel: Decodable {
    let geo: GeoModel
}

struct GeoModel: Decodable {
    let lat: String
    let lng: String
}
