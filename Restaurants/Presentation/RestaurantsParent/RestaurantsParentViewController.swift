//

import UIKit

protocol RestaurantsParentView: ViewProtocol {
    var presenter: RestaurantsParentPresenterProtocol! { get set }
    func changeViewState(viewState: RestaurantsParentViewState)
}

final class RestaurantsParentViewController: UIViewController, RestaurantsParentView {
    var presenter: RestaurantsParentPresenterProtocol!

    static var storyboardName: String {
        "RestaurantsParent"
    }

    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func changeViewState(viewState: RestaurantsParentViewState) {
        switch viewState {
        case .clear, .render:
            activityIndicator.isHidden = true
            segmentedControl.isUserInteractionEnabled = true
        case .loading:
            activityIndicator.isHidden = false
            segmentedControl.isUserInteractionEnabled = false
            break
        case .error(let message):
            activityIndicator.isHidden = true
            segmentedControl.isUserInteractionEnabled = true
            showAlert(title: "Error", actionTitle: "Retry", message: message) { [weak self] _ in
                self?.presenter.didTapRetryOption()
            }
        }
    }

    @IBAction private func didSelectSegment(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl else {
            return
        }
        presenter.didSelectTab(index: segmentedControl.selectedSegmentIndex)
    }
}

extension RestaurantsParentViewController: Alertable {}
