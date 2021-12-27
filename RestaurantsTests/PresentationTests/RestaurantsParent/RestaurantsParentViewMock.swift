@testable import Restaurants

final class RestaurantsParentViewMock: RestaurantsParentView {
    var presenter: RestaurantsParentPresenterProtocol!
    var viewState: RestaurantsParentViewState?

    func changeViewState(viewState: RestaurantsParentViewState) {
        self.viewState = viewState
    }
}
