import UIKit

class FeedViewController: UITableViewController {

    //MARK: - Properties

    private let feedService: FeedProvider
    private let factory: Factory.Type

    private let screenWidth = UIScreen.width
    private var photoPosts = [Photo]()
    private var pagesCount = 25
    private var totalPosts = 500
    private var nextPage = 1

    //MARK: - View Cycle

    init(feedService: FeedProvider, factory: Factory.Type) {
        self.feedService = feedService
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        setupView()
        postsRequest(page: 1)
    }

    //MARK: - Setup View

    private func setupView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.title = "Flickr's interestingness"
    }

    //MARK: - Networking

    private func postsRequest(page: Int) {
        feedService.getData(page: page) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let feedResponse):
                self.pagesCount = feedResponse.photos.pages
                self.totalPosts = feedResponse.photos.total
                self.photoPosts.append(contentsOf: feedResponse.photos.photo)
                self.nextPage += 1
            case .failure(let error):
                ErrorAlertService.showErrorAlert(error: error, viewController: self)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.feedService.isPaginating = false
        }
    }
}

//MARK: - Presentation logic

extension FeedViewController {
    private func presentPostController(with post: Photo) {
        let viewController = factory.makePostViewController(post: post)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - TableViewDataSource

extension FeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoPosts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = photoPosts[indexPath.row]
        let coefficient = screenWidth / CGFloat(post.widthM)
        return CGFloat(post.heightM) * coefficient
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath)
        guard let feelCell = cell as? FeedCell else { return cell }

        feelCell.imageProvider = ImageDownloader.shared
        feelCell.postImage.image = UIImage()
        feelCell.tag = indexPath.row
        let content = photoPosts[indexPath.row]
        feelCell.configure(with: content) { theTag in
            return theTag == indexPath.row
        }

        return feelCell
    }
}

//MARK: - ScrollViewDetegate

extension FeedViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !feedService.isPaginating else {
            return
        }
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 3000 - scrollView.frame.size.height),
           nextPage <= pagesCount,
           photoPosts.count <= totalPosts
        {
            postsRequest(page: nextPage)
        }
    }
}

//MARK: - TableViewDetegate

extension FeedViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentPostController(with: photoPosts[indexPath.row])
    }
}
