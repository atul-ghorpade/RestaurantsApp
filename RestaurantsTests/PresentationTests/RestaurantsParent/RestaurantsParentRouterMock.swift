@testable import Restaurants

final class RestaurantsParentRouterMock: RestaurantsParentRouterProtocol {
    var showRestaurantsListCalled = false
    var showRestaurantsMapCalled = false
    var model: RestaurantsInfoModel?
    var userLocation: LocationModel?

    func showRestaurantsList(model: RestaurantsInfoModel?,
                             delegate: RestaurantsListPresenterDelegate?) {
        showRestaurantsListCalled = true
        self.model = model
    }

    func showRestaurantsMap(userLocation: LocationModel,
                            model: RestaurantsInfoModel?) {
        showRestaurantsMapCalled = true
        self.userLocation = userLocation
    }
}
