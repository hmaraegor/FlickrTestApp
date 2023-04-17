import UIKit

protocol Factory {
    static func makeFeedViewController() -> UIViewController
    static func makePostViewController(post: Photo) -> UIViewController
}

enum ViewControllerFactory: Factory {
    static func makeFeedViewController() -> UIViewController {
        let networkService = NetworkService.shared
        let feedProvider = FeedService(networkService: networkService)
        let factory = ViewControllerFactory.self
        let viewController = FeedViewController(feedService: feedProvider, factory: factory)
        return viewController
    }

    static func makePostViewController(post: Photo) -> UIViewController {
        let imageProvider = ImageDownloader.shared
        let view: IPostView = ViewFactory.makePostView(post: post)
        let viewController = PostViewController(photoUrl: post.urlM, imageProvider: imageProvider, postView: view)
        return viewController
    }
}
