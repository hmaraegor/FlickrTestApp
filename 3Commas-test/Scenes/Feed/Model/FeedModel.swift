import Foundation

struct FeedModel: Codable {
    let photos: Photos
    let stat: String
    let message: String?
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
}

struct Photo: Codable {
    let id: String
    let owner: String
    let title: String
    let urlM: String
    let heightM: Int
    let widthM: Int

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case title
        case urlM = "url_m"
        case heightM = "height_m"
        case widthM = "width_m"
    }
}
