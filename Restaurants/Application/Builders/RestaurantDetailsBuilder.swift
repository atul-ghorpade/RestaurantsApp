//

import Foundation

final class RestaurantDetailsBuilder {
    func buildRestaurantDetailsView(router: RestaurantDetailsRouterProtocol,
                                    restaurantModel: RestaurantModel) -> RestaurantDetailsView {
        let restaurantDetailsView = RestaurantDetailsViewController.instantiate()
        restaurantDetailsView.presenter = buildRestaurantDetailsPresenter(view: restaurantDetailsView,
                                                                          router: router,
                                                                          restaurantModel: restaurantModel)
        return restaurantDetailsView
    }

    private func buildRestaurantDetailsPresenter(view: RestaurantDetailsView,
                                                 router: RestaurantDetailsRouterProtocol,
                                                 restaurantModel: RestaurantModel) -> RestaurantDetailsPresenterProtocol {
        return RestaurantDetailsPresenter(view: view,
                                          router: router,
                                          restaurantModel: restaurantModel,
                                          getRestaurantImageUseCase: buildRestaurantImageUseCase())
    }

    private func buildRestaurantImageUseCase() -> GetRestaurantImageDataUseCase {
        let providerProtocol = RestaurantsProvider()
        return GetRestaurantImageDataUseCase(provider: providerProtocol)
    }
}
