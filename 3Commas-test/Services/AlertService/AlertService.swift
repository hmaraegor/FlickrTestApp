import UIKit

class ErrorAlertService {

    private init() { }

    static func showErrorAlert(error: NetworkError, completionHandler: @escaping (UIAlertController) -> ()) {
        let errorMessage = error.rawValue
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            completionHandler(alert)
        }
    }
}
