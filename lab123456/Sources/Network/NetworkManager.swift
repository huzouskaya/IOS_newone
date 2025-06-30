import Foundation

final class NetworkManager {
// final class is a class which cannot be a parent class
    static let shared = NetworkManager()
    // we create a single instance of the class. global. singletone pattern
    private let baseURL = "https://fakestoreapi.com"
    // the API base address to which we will make requests
    private let urlSession = URLSession.shared
    // the URLSession instance that will execute network requests
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) 
    // completion is the closure (замыкание) that will be called upon completion of the query
    // @escaping means that this closure can be called after returning from the function
    // Result contains Product or Error
    {
        let endpoint = "/products"
        // endpoint will be added to baseURL. we have a string. we transform it to URL
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            // In case of an error we call completion with an error . invalidURL
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
