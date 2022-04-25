import Foundation

protocol FeedProvider: AnyObject {
    func getData(page: Int, completionHandler: @escaping (Result<FeedModel, NetworkError>) -> ())
    var isPaginating: Bool { get set }
}
