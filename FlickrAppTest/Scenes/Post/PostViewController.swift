import UIKit

class PostViewController: UIViewController {

    // MARK: - Properties

    private let screenWidth = UIScreen.width
    private let imageProvider: ImageProvider
    private let mainView: IPostView
    private let photoUrl: String

    // MARK: - Life cycle

    init(photoUrl: String, imageProvider: ImageProvider, postView: IPostView) {
        self.mainView = postView
        self.photoUrl = photoUrl
        self.imageProvider = imageProvider
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
        imageProvider.getImage(stringURL: photoUrl) { (image) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.mainView.postImage.image = image
                self.mainView.activityIndicator.stopAnimating()
            }
        }
    }
}
