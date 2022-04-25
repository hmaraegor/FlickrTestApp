import UIKit

class PostViewController: UIViewController {

    // MARK: - Properties

    private var presenter: PostPresenterProtocol
    private let mainView: IPostView
    private let photoUrl: String

    // MARK: - Life cycle

    init(photoUrl: String, presenter: PostPresenterProtocol, postView: IPostView) {
        self.mainView = postView
        self.photoUrl = photoUrl
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhoto()
    }

    // MARK: - Setup views

    private func fetchPhoto() {
        mainView.activityIndicator.startAnimating()
        presenter.fetchPhoto(photoUrl: photoUrl)
    }
}

extension PostViewController: PostPresenterDelegate {
    func presentPhoto(photo: UIImage) {
        self.mainView.postImage.image = photo
        self.mainView.activityIndicator.stopAnimating()
    }
}
