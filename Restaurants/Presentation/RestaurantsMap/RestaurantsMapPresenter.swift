//

import Foundation
import CoreLocation

protocol RestaurantsMapPresenterProtocol: PresenterProtocol {
    func didSelectAnnotation(coordinate: CLLocationCoordinate2D?)
}

enum RestaurantsMapViewState: Equatable {
    case clear
    case render(viewModel: ViewModel)

    struct ViewModel: Equatable {
        let userLocation: CLLocationCoordinate2D
        let restaurantsLocations: [LocationViewModel]
        let latitudeDelta: CLLocationDegrees
        let longitudeDelta: CLLocationDegrees
    }

    struct LocationViewModel: Equatable {
        let location: CLLocationCoordinate2D
        let title: String
        let subtitle: String
    }
}

final class RestaurantsMapPresenter: RestaurantsMapPresenterProtocol {

    private weak var view: RestaurantsMapView?

    private weak var router: RestaurantsMapRouterProtocol!
    private var restaurantsModels: [RestaurantModel]?
    private var userLocation: LocationModel
    private let latitudeDelta: CLLocationDegrees = 0.01
    private let longitudeDelta: CLLocationDegrees = 0.01

    private var viewState: RestaurantsMapViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.changeViewState(viewState: viewState)
        }
    }

    init(view: RestaurantsMapView?,
         userLocation: LocationModel,
         router: RestaurantsMapRouterProtocol) {
        self.view = view
        self.userLocation = userLocation
        self.router = router
    }

    func viewLoaded() {
        calculateViewState()
    }

    func didSelectAnnotation(coordinate: CLLocationCoordinate2D?) {
        guard let selectedCoordinate = coordinate,
              let restaurantsList = restaurantsModels else {
            return
        }
        let selectedLocationModel = LocationModel(coordinates: selectedCoordinate)
        let selectedRestaurantModel = restaurantsList.first {
            $0.locationModel == selectedLocationModel
        }
        if let selectedRestaurantModel = selectedRestaurantModel {
            router.showRestaurantDetails(model: selectedRestaurantModel)
        }
    }

    private func getLocationViewModel(restaurantModel: RestaurantModel) -> RestaurantsMapViewState.LocationViewModel {
        let coordinates = CLLocationCoordinate2DMake(restaurantModel.locationModel.latitude,
                                                     restaurantModel.locationModel.longitude)
        let title = restaurantModel.name
        var subtitle: String = ""
        if let isOpen = restaurantModel.openStatus {
            subtitle = isOpen ? "Currently Open" : "Currently Closed"
        }
        return RestaurantsMapViewState.LocationViewModel(location: coordinates,
                                                         title: title,
                                                         subtitle: subtitle)
    }

    private func calculateViewState() {
        let userLocationCoordinates = CLLocationCoordinate2DMake(userLocation.latitude,
                                                                 userLocation.longitude)
        let restaurantLocationsViewModels = restaurantsModels?.compactMap {
            getLocationViewModel(restaurantModel: $0)
        }

        let viewModel = RestaurantsMapViewState.ViewModel(userLocation: userLocationCoordinates,
                                                          restaurantsLocations: restaurantLocationsViewModels ?? [],
                                                          latitudeDelta: self.latitudeDelta,
                                                          longitudeDelta: self.longitudeDelta)
        viewState = .render(viewModel: viewModel)
    }
}

extension RestaurantsMapPresenter: RestaurantsMapChildPresenterProtocol {
    func setRestaurantsInfoModel(_ model: RestaurantsInfoModel?,
                                 userLocation: LocationModel) {
        self.restaurantsModels = model?.restaurantsModels ?? []
        self.userLocation = userLocation
        calculateViewState()
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}
