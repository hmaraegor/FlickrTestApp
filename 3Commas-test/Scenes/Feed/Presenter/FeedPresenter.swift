import UIKit

protocol FeedPresenterDelegate: AnyObject {
    func presentPosts(posts: [Photo])
    func presentAlert(error: NetworkError)
}

typealias PressenterDelegate = FeedPresenterDelegate & UIViewController

protocol FeedPresenterProtocol: AnyObject {
    func didTapPost(photoPost: Photo)
    func getPosts()
    func getMorePosts()
    var isPaginating: Bool { get }
}

class FeedPresenter: FeedPresenterProtocol {

    weak var delegate: PressenterDelegate?
    private var feedService: FeedProvider
    private var posts: [Photo] = []

    private let screenWidth = UIScreen.width
    private var pagesCount = 25
    private var totalPosts = 500
    private var nextPage = 1

    init(feedService: FeedProvider) {
        self.feedService = feedService
    }

    public func getPosts() {
        feedService.getData(page: nextPage) { [weak self] (result: Result<FeedModel, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let feedModel):
                self.posts.append(contentsOf: feedModel.photos.photo)
                self.pagesCount = feedModel.photos.pages
                self.totalPosts = feedModel.photos.total
                self.nextPage += 1
                self.delegate?.presentPosts(posts: self.posts)
            case .failure(let error):
                self.delegate?.presentAlert(error: error)
            }
            self.feedService.isPaginating = false
        }
    }

    var isPaginating: Bool {
        feedService.isPaginating
    }

    func getMorePosts() {
        if nextPage <= pagesCount, posts.count <= totalPosts {
            getPosts()
        }
    }

    public func didTapPost(photoPost: Photo) {
        let viewController = ViewControllerFactory.makePostViewController(post: photoPost)
        delegate?.navigationController?.pushViewController(viewController, animated: true)
    }

}
