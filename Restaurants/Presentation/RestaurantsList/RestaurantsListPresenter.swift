//

import Foundation

protocol RestaurantsListPresenterProtocol: PresenterProtocol, TableViewDataSource {
    func didScrollBeyondCurrentPage()
    func didSelectRow(indexPath: IndexPath)
}

enum RestaurantsListViewState: Equatable {
    case clear
    case loading
    case render(viewModel: ViewModel)

    struct ViewModel: Equatable {
        let rowsViewModels: [RestaurantCellViewModel]
    }
}

protocol RestaurantsListPresenterDelegate: AnyObject {
    func handleNextPageRequest()
}

final class RestaurantsListPresenter: RestaurantsListPresenterProtocol {

    private weak var view: RestaurantsListView?
    private weak var delegate: RestaurantsListPresenterDelegate?

    private weak var router: RestaurantsListRouterProtocol!
    private var restaurantsInfoModel: RestaurantsInfoModel?

    private var viewState: RestaurantsListViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.changeViewState(viewState: viewState)
        }
    }

    init(view: RestaurantsListView?,
         router: RestaurantsListRouterProtocol,
         delegate: RestaurantsListPresenterDelegate?) {
        self.view = view
        self.router = router
        self.delegate = delegate
    }

    func viewLoaded() {}

    func didSelectRow(indexPath: IndexPath) {
        guard let restaurantsInfoModel = restaurantsInfoModel else {
            return
        }
        let selectedRestaurantModel = restaurantsInfoModel.restaurantsModels[indexPath.row]
        router.showRestaurantDetails(model: selectedRestaurantModel)
    }

    func didScrollBeyondCurrentPage() {
        guard viewState != .loading, !isAllModelsDisplayed() else { // already loading or all models availble
            return
        }
        viewState = .loading
        delegate?.handleNextPageRequest()
    }

    private func getCellViewModel(restaurantModel: RestaurantModel) -> RestaurantCellViewModel {
        var statusString: String?
        if let status = restaurantModel.openStatus {
            statusString = status ? "Open" : "Closed"
        }
        return RestaurantCellViewModel(imageURL: restaurantModel.imageURL,
                                       name: restaurantModel.name,
                                       status: statusString)
    }

    private func isAllModelsDisplayed() -> Bool {
        let isAllModelsAlreadyReceived = !(restaurantsInfoModel?.restaurantsModels ?? []).isEmpty &&
        (restaurantsInfoModel?.nextPageInfo == nil)
        if isAllModelsAlreadyReceived {
            print("All available restaurants are already displayed")
        }
        return isAllModelsAlreadyReceived
    }
}

extension RestaurantsListPresenter: TableViewDataSource {
    func numberOfRowsInSection(section: Int) -> Int {
        restaurantsInfoModel?.restaurantsModels.count ?? 0
    }

    func viewModelForCell(at indexPath: IndexPath) -> CellViewModel? {
        guard let restaurantModel = restaurantsInfoModel?.restaurantsModels[indexPath.row] else {
            return nil
        }
        let cellViewModel = getCellViewModel(restaurantModel: restaurantModel)
        return cellViewModel
    }
}

extension RestaurantsListPresenter: RestaurantsListChildPresenterProtocol {
    func setRestaurantsInfoModel(_ model: RestaurantsInfoModel?) {
        restaurantsInfoModel = model
        let rowsViewModels = (restaurantsInfoModel?.restaurantsModels ?? []).map {
            getCellViewModel(restaurantModel: $0)
        }
        let screenViewModel = RestaurantsListViewState.ViewModel(rowsViewModels: rowsViewModels)
        viewState = .render(viewModel: screenViewModel)
    }
}
