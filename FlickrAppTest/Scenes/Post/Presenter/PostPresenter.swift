import UIKit

protocol PostPresenterDelegate: AnyObject {
    func presentPhoto(photo: UIImage)
}

protocol PostPresenterProtocol: AnyObject {
    func fetchPhoto(photoUrl: String)
}

class PostPresenter: PostPresenterProtocol {

    weak var delegate: PostPresenterDelegate?
    private var imageProvider: ImageProvider

    init(imageProvider: ImageProvider) {
        self.imageProvider = imageProvider
    }

    public func fetchPhoto(photoUrl: String) {
        imageProvider.getImage(stringURL: photoUrl) { (image) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.presentPhoto(photo: image)
            }
        }
    }
}
