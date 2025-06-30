import Foundation
struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price
        case description = "product_description"
        case image = "image_url"
    }
}
