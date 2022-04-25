import UIKit

//MARK: - Presenter Delegate

extension FeedViewController: FeedPresenterDelegate {

    func presentPosts(posts: [Photo]) {
        photoPosts = posts
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func presentAlert(error: NetworkError) {
        ErrorAlertService.showErrorAlert(error: error) { [weak self] alert in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - ViewController

class FeedViewController: UITableViewController {

    //MARK: - Properties

    private let presenter: FeedPresenterProtocol
    private let imageProvider: ImageProvider

    private let screenWidth = UIScreen.width
    private var photoPosts = [Photo]()

    //MARK: - View Cycle

    init(presenter: FeedPresenterProtocol, imageProvider: ImageProvider) {
        self.presenter = presenter
        self.imageProvider = imageProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        setupView()
        presenter.getPosts()
    }

    //MARK: - Setup View

    private func setupView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.title = "Flickr's interestingness"
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

        feelCell.postImage.image = UIImage()
        feelCell.tag = indexPath.row
        let content = photoPosts[indexPath.row]
        feelCell.configure(
            with: content,
            imageProvider: imageProvider
        ) { theTag in
            return theTag == indexPath.row
        }

        return feelCell
    }
}

//MARK: - ScrollViewDetegate

extension FeedViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !presenter.isPaginating else { return }
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 3000 - scrollView.frame.size.height) {
            presenter.getMorePosts()
        }
    }
}

//MARK: - TableViewDetegate

extension FeedViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapPost(photoPost: photoPosts[indexPath.row])
    }
}
