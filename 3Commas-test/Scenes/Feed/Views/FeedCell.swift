import UIKit

class FeedCell: UITableViewCell {

    // MARK: - UI Components

    lazy var postImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.random
        view.contentMode = .scaleAspectFill
        return view
    }()

    // MARK: - Properties

    static let identifier = String(describing: FeedCell.self)
    var imageProvider: ImageProvider?

    // MARK: - Setup views

    func configure(with photoPost: Photo, completion: @escaping (Int) -> Bool) {
        let stringURL = photoPost.urlM
        setupViews()

        guard let imageProvider = imageProvider else { return }
        imageProvider.getImage(stringURL: stringURL) { (image) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if completion(self.tag) {
                    self.postImage.image = image
                }
            }
        }
    }

    private func setupViews() {
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews(){
        contentView.addSubviews(postImage)
    }

    private func setupConstraints() {
        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
