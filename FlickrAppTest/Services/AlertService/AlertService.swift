import UIKit

class ErrorAlertService {

    private init() { }

    static func showErrorAlert(error: NetworkServiceError, viewController: UIViewController) {
        let errorMessage = error.rawValue
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
