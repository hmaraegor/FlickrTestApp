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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.title = try container.decode(String.self, forKey: .title)
        self.urlM = try container.decodeIfPresent(String.self, forKey: .urlM) ?? ""
        self.heightM = try container.decodeIfPresent(Int.self, forKey: .heightM) ?? 0
        self.widthM = try container.decodeIfPresent(Int.self, forKey: .widthM) ?? 0
    }
}
