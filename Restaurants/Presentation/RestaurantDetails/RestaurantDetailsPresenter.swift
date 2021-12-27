import Foundation

protocol RestaurantDetailsPresenterProtocol: PresenterProtocol {
    func startNavigationButtonPressed()
}

enum RestaurantDetailsViewState: Equatable {
    case clear
    case render(viewModel: ViewModel)

    struct ViewModel: Equatable {
        let name: String
        let address: String
        let status: String
        let imageData: Data?
    }
}

final class RestaurantDetailsPresenter: RestaurantDetailsPresenterProtocol {
    private weak var view: RestaurantDetailsView?

    private weak var router: RestaurantDetailsRouterProtocol!
    private var restaurantModel: RestaurantModel!
    private var getRestaurantImageUseCase: GetRestaurantImageDataUseCase!
    private var imageData: Data?

    private var viewState: RestaurantDetailsViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.changeViewState(viewState: viewState)
        }
    }

    init(view: RestaurantDetailsView?,
         router: RestaurantDetailsRouterProtocol,
         restaurantModel: RestaurantModel,
         getRestaurantImageUseCase: GetRestaurantImageDataUseCase) {
        self.view = view
        self.router = router
        self.restaurantModel = restaurantModel
        self.getRestaurantImageUseCase = getRestaurantImageUseCase
    }

    func viewLoaded() {
        calculateViewState()
        loadRestaurantImage()
    }

    func startNavigationButtonPressed() {
        router.showMapNavigation(name: restaurantModel.name,
                                 locationModel: restaurantModel.locationModel)
    }

    private func loadRestaurantImage() {
        guard let imageReference = restaurantModel.photoReference else {
            return
        }
        let params = GetRestaurantImageDataParams(imageReference: imageReference) { [weak self] result in
            guard let self = self else {
                return
            }
            if case .success(let imageData) = result {
                self.imageData = imageData
                self.calculateViewState()
            }
        }
        getRestaurantImageUseCase.run(params)
    }

    private func calculateViewState() {
        var openStatusString: String?
        if let status = restaurantModel.openStatus {
            openStatusString = status ? "Open now" : "Closed now"
        }
        let viewModel = RestaurantDetailsViewState.ViewModel(name: restaurantModel.name,
                                                             address: restaurantModel.address ?? "Not Available",
                                                             status: openStatusString ?? "Not Available",
                                                             imageData: imageData)
        viewState = .render(viewModel: viewModel)
    }
}
