//

import Foundation
import UIKit

final class AppRouter {
    private let navigationController: UINavigationController
    private let appBuilder: AppBuilder
    private var restaurantsRouter: RestaurantsRouter?

    init(navigationController: UINavigationController,
         appBuilder: AppBuilder) {
        self.navigationController = navigationController
        self.appBuilder = appBuilder
    }

    func start() {
        let restaurantsRouter = RestaurantsRouter(navigationController: navigationController)
        restaurantsRouter.start()
        self.restaurantsRouter = restaurantsRouter
    }
}
