//

import UIKit

protocol RestaurantDetailsView: ViewProtocol {
    var presenter: RestaurantDetailsPresenterProtocol! { get set }
    func changeViewState(viewState: RestaurantDetailsViewState)
}

final class RestaurantDetailsViewController: UIViewController, RestaurantDetailsView {
    var presenter: RestaurantDetailsPresenterProtocol!

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameDetailLabel: UILabel!
    @IBOutlet private weak var addressDetailLabel: UILabel!
    @IBOutlet private weak var statusDetailLabel: UILabel!
    
    static var storyboardName: String {
        "RestaurantDetails"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }

    func changeViewState(viewState: RestaurantDetailsViewState) {
        switch viewState {
        case .clear:
            break
        case .render(let viewModel):
            renderViewModel(viewModel: viewModel)
        }
    }

    private func renderViewModel(viewModel: RestaurantDetailsViewState.ViewModel) {
        nameDetailLabel.text = viewModel.name
        addressDetailLabel.text = viewModel.address
        statusDetailLabel.text = viewModel.status
        if let imageData = viewModel.imageData {
            let image = UIImage(data: imageData)
            imageView.image = image
            imageView.backgroundColor = .clear
        }
    }

    @IBAction private func startNavigationButtonPressed(_ sender: Any) {
        presenter.startNavigationButtonPressed()
    }
}
