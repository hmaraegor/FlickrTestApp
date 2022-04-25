import Foundation

enum NetworkServiceError: String, Error  {
    case badURL = "URL has incorrect format"
    case noResponse = "Response was not received"
    case noData = "Data was not received"
    case jsonDecoding = "Data decoding error"
    case networkError = "Network error"
    case badResponse = "Response returned an error"
    //TODO add codes
}
