import UIKit

protocol Factory {
    static func makeFeedViewController() -> UIViewController
    static func makePostViewController(post: Photo) -> UIViewController
}

enum ViewControllerFactory: Factory {
    static func makeFeedViewController() -> UIViewController {
        let networkService = NetworkService.shared
        let feedProvider = FeedService(networkService: networkService)
        let presenter = FeedPresenter(feedService: feedProvider)
        let imageProvider = ImageDownloader.shared
        let viewController = FeedViewController(presenter: presenter, imageProvider: imageProvider)
        presenter.delegate = viewController
        return viewController
    }

    static func makePostViewController(post: Photo) -> UIViewController {
        let imageProvider = ImageDownloader.shared
        let view: IPostView = ViewFactory.makePostView(post: post)
        let presenter = PostPresenter(imageProvider: imageProvider)
        let viewController = PostViewController(photoUrl: post.urlM, presenter: presenter, postView: view)
        presenter.delegate = viewController
        return viewController
    }
}
