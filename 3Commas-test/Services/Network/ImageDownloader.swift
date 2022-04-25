import UIKit

class ImageDownloader {

    private init() { }

    static let shared = ImageDownloader()

    let imageCache = NSCache<AnyObject, UIImage>()

    func downloadImage(
        stringURL: String,
        completionHandler: @escaping (Data) -> ()
    ) {

        DispatchQueue.global().async {
            guard let imageUrl = URL(string: stringURL) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            completionHandler(imageData)
        }
    }
}

extension ImageDownloader: ImageProvider {

    func getImage(stringURL: String, completionHandler: @escaping (UIImage) -> ()) {

        if let imageCache = imageCache.object(forKey: stringURL as AnyObject) {
            completionHandler(imageCache)
        }

        downloadImage(stringURL: stringURL) { (imageData) in
            guard let image = UIImage(data: imageData) else { return }
            self.imageCache.setObject(image, forKey: stringURL as AnyObject)
            completionHandler(image)
        }
    }
}

