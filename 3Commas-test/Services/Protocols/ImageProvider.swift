import UIKit

protocol ImageProvider {
    func getImage(stringURL: String, completionHandler: @escaping (UIImage) -> ())
}
