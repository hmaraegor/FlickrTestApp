import Foundation

class FeedService: FeedProvider {
    private let queryItems: [URLQueryItem] = [
        URLQueryItem(name: "method", value: "flickr.interestingness.getList"),
        URLQueryItem(name: "api_key", value: "72c24febb369aa46b6860a83db5e63e0"),
        URLQueryItem(name: "per_page", value: "20"),
        URLQueryItem(name: "date", value: ""),
        URLQueryItem(name: "extras", value: "url_m,url_l"),
        URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "nojsoncallback", value: "1")
    ]

    private let stringUrl = "https://www.flickr.com/services/rest/"
    var isPaginating = false
    let networkService: INetworkService

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func getData(
        page: Int,
        completionHandler: @escaping (Result<FeedModel, NetworkError>) -> ()
    ) {
        isPaginating = true
        var queryItems = queryItems
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))

        guard var components = URLComponents(string: stringUrl) else { return }
        components.queryItems = queryItems
        guard let url = components.url else { return }
        let request = URLRequest(url: url)

        networkService.getData(request: request, completionHandler: completionHandler)
    }
}
