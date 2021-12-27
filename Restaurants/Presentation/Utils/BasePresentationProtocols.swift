//

import Foundation
import UIKit

protocol StoryboardInstantiable: AnyObject {
    static var storyboard: UIStoryboard { get }
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String { get }
    static var storyboardBundle: Bundle { get }
}

extension StoryboardInstantiable {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    }

    static var storyboardBundle: Bundle {
        Bundle(for: self)
    }

    static var viewControllerIdentifier: String {
        String(describing: self)
    }

    static var storyboardName: String {
        ""
    }
}

extension StoryboardInstantiable {
    static func instantiate() -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        guard let typedViewController = viewController as? Self else {
            fatalError("ViewController '\(viewControllerIdentifier)' of '\(storyboard)' is not of class '\(self)'")
        }

        return typedViewController
    }
}

protocol ViewProtocol: StoryboardInstantiable {}

protocol PresenterProtocol {
    func viewLoaded()
    func viewAppeared()
}

extension PresenterProtocol {
    func viewLoaded() {}
    func viewAppeared() {}
}

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
