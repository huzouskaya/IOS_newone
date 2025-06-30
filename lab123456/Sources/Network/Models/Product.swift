import Foundation
struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: URL?
    let rating: Rating?
    
    struct Rating: Decodable {
        let rate: Double
        let count: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, description, category, image, rating
    }
}
