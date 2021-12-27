//

import Foundation

final class RestaurantsParentBuilder {
    func buildRestaurantsParentView(router: RestaurantsParentRouterProtocol) -> RestaurantsParentView {
        let restaurantsParentView = RestaurantsParentViewController.instantiate()
        restaurantsParentView.presenter = buildRestaurantsParentPresenter(view: restaurantsParentView,
                                                                          router: router)
        return restaurantsParentView
    }

    private func buildRestaurantsParentPresenter(view: RestaurantsParentView,
                                                 router: RestaurantsParentRouterProtocol) -> RestaurantsParentPresenterProtocol {
        let getRestaurantsUseCaseProtocol = buildGetRestaurantsUseCase()
        return RestaurantsParentPresenter(view: view,
                                          getRestaurantsUseCase: getRestaurantsUseCaseProtocol,
                                          router: router)
    }

    private func buildGetRestaurantsUseCase() -> GetRestaurantsUseCaseProtocol {
        let providerProtocol = RestaurantsProvider()
        return GetRestaurantsUseCase(provider: providerProtocol)
    }
}
