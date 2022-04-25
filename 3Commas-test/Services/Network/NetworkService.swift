import Foundation

protocol INetworkService {
    func getData<T: Decodable>( request: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> ())
}

class NetworkService: INetworkService {

    static let shared = NetworkService()

    private init() {}

    func getData<T: Decodable>(
        request: URLRequest,
        completionHandler: @escaping (Result<T, NetworkServiceError>) -> ()
    ) {

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response else {
                completionHandler(.failure(.noResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            if error != nil {
                completionHandler(.failure(.networkError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {

              //TODO: other codes
                completionHandler(.failure(.badResponse))
                return
            }

            do {
                let content: T = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(content))
            } catch {
                completionHandler(.failure(.jsonDecoding))
            }

        }.resume()
    }
}
