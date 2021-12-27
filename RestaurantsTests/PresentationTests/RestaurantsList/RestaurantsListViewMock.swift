@testable import Restaurants

final class RestaurantsListViewMock: RestaurantsListView {
    var presenter: RestaurantsListPresenterProtocol!
    var viewState: RestaurantsListViewState?

    func changeViewState(viewState: RestaurantsListViewState) {
        self.viewState = viewState
    }
}
