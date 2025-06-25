import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://fakestoreapi.com"
    private let urlSession = URLSession.shared
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let endpoint = "/products"
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
