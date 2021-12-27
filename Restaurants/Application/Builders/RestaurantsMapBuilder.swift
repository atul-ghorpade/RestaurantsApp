//

import Foundation

final class RestaurantsMapBuilder {
    func buildRestaurantsMapView(router: RestaurantsMapRouterProtocol,
                                 userLocation: LocationModel) -> RestaurantsMapView {
        let restaurantsMapView = RestaurantsMapViewController.instantiate()
        restaurantsMapView.presenter = buildRestaurantsMapPresenter(view: restaurantsMapView,
                                                                    userLocation: userLocation,
                                                                    router: router)
        return restaurantsMapView
    }

    private func buildRestaurantsMapPresenter(view: RestaurantsMapView,
                                              userLocation: LocationModel,
                                              router: RestaurantsMapRouterProtocol) -> RestaurantsMapPresenterProtocol {
        return RestaurantsMapPresenter(view: view,
                                       userLocation: userLocation,
                                       router: router)
    }
}
