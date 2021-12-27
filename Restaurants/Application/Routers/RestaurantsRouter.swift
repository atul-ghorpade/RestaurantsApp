//

import UIKit

final class RestaurantsRouter {
    private weak var navigationController: UINavigationController?
    private weak var restaurantsParentViewController: UIViewController?
    private var restaurantsListViewController: UIViewController?
    private var restaurantsMapViewController: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let restaurantsParentViewController = RestaurantsParentBuilder().buildRestaurantsParentView(router: self) as? UIViewController else {
            fatalError("RestaurantsParentViewController not built")
        }
        navigationController?.pushViewController(restaurantsParentViewController, animated: false)
        self.restaurantsParentViewController = restaurantsParentViewController
    }
}

protocol RestaurantsParentRouterProtocol: AnyObject {
    func showRestaurantsList(model: RestaurantsInfoModel?,
                             delegate: RestaurantsListPresenterDelegate?)
    func showRestaurantsMap(userLocation: LocationModel,
                            model: RestaurantsInfoModel?)
}

protocol RestaurantsListRouterProtocol: AnyObject {
    func showRestaurantDetails(model: RestaurantModel)
}

protocol RestaurantsMapRouterProtocol: AnyObject {
    func showRestaurantDetails(model: RestaurantModel)
}

protocol RestaurantDetailsRouterProtocol: AnyObject {
    func showMapNavigation(name: String, locationModel: LocationModel)
}

extension RestaurantsRouter: RestaurantsParentRouterProtocol {
    func showRestaurantsList(model: RestaurantsInfoModel?, delegate: RestaurantsListPresenterDelegate?) {
        if restaurantsListViewController == nil { // ListViewController not initialized
            guard let builtRestaurantsListViewController = RestaurantsListBuilder().buildRestaurantsListView(router: self,
                                                                                                             delegate: delegate) as? UIViewController else {
                fatalError("RestaurantsListViewController not built")
            }
            self.restaurantsListViewController = builtRestaurantsListViewController
        }
        if let restaurantsListViewController = restaurantsListViewController {
            restaurantsParentViewController?.children.forEach {
                $0.removeChildFromParent()
            }
            restaurantsParentViewController?.add(restaurantsListViewController)
            ((restaurantsListViewController as? RestaurantsListView)?.presenter as? RestaurantsChildPresenterProtocol)?.setRestaurantsInfoModel(model)
        }
    }
    
    func showRestaurantsMap(userLocation: LocationModel, model: RestaurantsInfoModel?) {
        if restaurantsMapViewController == nil { // MapViewController not initialized
            guard let builtRestaurantsMapViewController = RestaurantsMapBuilder().buildRestaurantsMapView(router: self,
                                                                                                          userLocation: userLocation) as? UIViewController else {
                fatalError("RestaurantsMapViewController not built")
            }
            self.restaurantsMapViewController = builtRestaurantsMapViewController
        }
        if let restaurantsMapViewController = restaurantsMapViewController {
            restaurantsParentViewController?.children.forEach {
                $0.removeChildFromParent()
            }
            restaurantsParentViewController?.add(restaurantsMapViewController)
            ((restaurantsMapViewController as? RestaurantsMapView)?.presenter as? RestaurantsChildPresenterProtocol)?.setRestaurantsInfoModel(model)
        }
    }
}

extension RestaurantsRouter: RestaurantsListRouterProtocol, RestaurantsMapRouterProtocol {
    func showRestaurantDetails(model: RestaurantModel) {
        guard let restaurantDetailsViewController = RestaurantDetailsBuilder().buildRestaurantDetailsView(router: self,
                                                                                                       restaurantModel: model) as? UIViewController else {
            fatalError("RestaurantsListViewController not built")
        }
        navigationController?.pushViewController(restaurantDetailsViewController,
                                                 animated: true)
    }
}

extension RestaurantsRouter: RestaurantDetailsRouterProtocol {
    func showMapNavigation(name: String, locationModel: LocationModel) {
        MapsRouter().startNavigation(name: name, locationModel: locationModel)
    }
}

extension UIViewController {
   func add(_ child: UIViewController) {
       addChild(child)
       view.insertSubview(child.view, at: 0)
       child.didMove(toParent: self)
   }

   func removeChildFromParent() {
       guard parent != nil else {
           return
       }
       willMove(toParent: nil)
       removeFromParent()
       view.removeFromSuperview()
   }
}
