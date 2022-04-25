import UIKit

protocol IPostView: UIView {
    var activityIndicator: UIActivityIndicatorView { get }
    var postImage: UIImageView { get }
}

class PostView: UIView, IPostView {
    
    // MARK: - UI Components

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .white
        view.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.hidesWhenStopped = true
        return view
    }()

    lazy var postImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.random
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var label: UILabel = {
        let view = UILabel()
        view.textColor = .gray
        view.numberOfLines = 0
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()

    // MARK: - Properties

    private let photoHeight: Int
    private let photoWidth: Int
    private let postTitle: String
    private var screenWidth = UIScreen.width

    required init(heightOfphoto: Int, widtOfphoto: Int, title: String) {
        photoHeight = heightOfphoto
        photoWidth = widtOfphoto
        postTitle = title
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        label.text = postTitle
        setupSubviews()
        setupConstraints()
    }
    

    private func setupSubviews() {
        addSubviews(scrollView)
        scrollView.addSubviews(stackView, activityIndicator)
        let stackSubviews = [
            postImage,
            label
        ]
        stackView.addArrangedSubviews(stackSubviews)
    }

    private func setupConstraints() {
        let coefficient = screenWidth / CGFloat(photoWidth)
        let photoHeight = CGFloat(photoHeight) * coefficient

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: stackView.topAnchor),
            postImage.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            postImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            postImage.heightAnchor.constraint(equalToConstant: photoHeight)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10)
        ])

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: postImage.centerYAnchor)
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
