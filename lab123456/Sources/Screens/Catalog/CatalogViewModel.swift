final class CatalogViewModel {
    private let networkManager = NetworkManager.shared
    var products: [Product] = []
    
    func fetchProducts(completion: @escaping () -> Void) {
        networkManager.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                completion()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
