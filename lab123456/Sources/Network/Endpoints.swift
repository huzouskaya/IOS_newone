enum Endpoint {
    case products
    case product(id: Int)
    case categories
    
    var path: String {
        switch self {
        case .products: return "/products"
        case .product(let id): return "/products/\(id)"
        case .categories: return "/products/categories"
        }
    }
}
