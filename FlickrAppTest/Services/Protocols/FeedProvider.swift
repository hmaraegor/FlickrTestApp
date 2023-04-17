import Foundation

protocol FeedProvider: AnyObject {
    func getData(page: Int, completionHandler: @escaping (Result<FeedModel, NetworkServiceError>) -> ())
    var isPaginating: Bool { get set }
}
