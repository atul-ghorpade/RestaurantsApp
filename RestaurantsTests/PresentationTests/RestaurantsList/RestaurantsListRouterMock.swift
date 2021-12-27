@testable import Restaurants

final class RestaurantsListRouterMock: RestaurantsListRouterProtocol {
    var showRestaurantsDetailsCalled = false
    var model: RestaurantModel?

    func showRestaurantDetails(model: RestaurantModel) {
        showRestaurantsDetailsCalled = true
        self.model = model
    }
}
