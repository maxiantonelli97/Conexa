import Foundation

struct NewsModel: Decodable, Identifiable {
    let id: Int
    let title: String
    let body: String
}
