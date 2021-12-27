//

@testable import Restaurants

import XCTest
import CoreLocation

class RestaurantsParentPresenterTests: XCTestCase {
    private var presenter: RestaurantsParentPresenter!
    private var viewMock: RestaurantsParentViewMock!
    private var getRestaurantsUseCaseMock: GetRestaurantsUseCaseMock!
    private var routerMock: RestaurantsParentRouterMock!

    override func setUp() {
        super.setUp()
        viewMock = RestaurantsParentViewMock()
        getRestaurantsUseCaseMock = GetRestaurantsUseCaseMock()
        routerMock = RestaurantsParentRouterMock()
        presenter = RestaurantsParentPresenter(view: viewMock,
                                               getRestaurantsUseCase: getRestaurantsUseCaseMock,
                                               router: routerMock)

    }

    func testDidUpdateLocationViewState() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        getRestaurantsUseCaseMock.result = .success(restaurantInfoModel)
        let locationManagerMock = LocationManagerMock()
        locationManagerMock.mockLocation = CLLocation(latitude: 0.4, longitude: 0.4)

        // When
        presenter.locationManager(locationManagerMock, didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)])

        // Then
        XCTAssertEqual(viewMock.viewState, .render)
    }

    func testDidUpdateLocationListScreenAddition() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        getRestaurantsUseCaseMock.result = .success(restaurantInfoModel)
        let locationManagerMock = LocationManagerMock()
        locationManagerMock.mockLocation = CLLocation(latitude: 0.4, longitude: 0.4)

        // When
        presenter.locationManager(locationManagerMock, didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)])

        // Then
        XCTAssert(routerMock.showRestaurantsListCalled)
        XCTAssertEqual(routerMock.model, restaurantInfoModel)
    }

    func testGetRestaurantsFailure() {
        // Given
        let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
        let useCaseError = UseCaseError.underlying(error)
        getRestaurantsUseCaseMock.result = .failure(useCaseError)

        let locationManagerMock = LocationManagerMock()
        locationManagerMock.mockLocation = CLLocation(latitude: 0.4, longitude: 0.4)

        // When
        presenter.locationManager(locationManagerMock, didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)])

        // Then
        XCTAssertEqual(viewMock.viewState,
                       .error(message: "Unable to get restaurants list, please try after some time"))
    }

    func testGetLocationFailure() {
        // Given
        let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
        let useCaseError = UseCaseError.underlying(error)
        getRestaurantsUseCaseMock.result = .failure(useCaseError)

        let locationManagerMock = LocationManagerMock()
        locationManagerMock.mockLocation = CLLocation(latitude: 0.4, longitude: 0.4)
        locationManagerMock.mockAuthorizationStatus = .denied

        // When
        presenter.locationManager(locationManagerMock, didChangeAuthorization: .denied)

        // Then
        XCTAssertEqual(viewMock.viewState,
                        .error(message: "Cannot access location, please authorize the app to access location."))
    }

    func testMapTabSelected() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        getRestaurantsUseCaseMock.result = .success(restaurantInfoModel)
        let locationManagerMock = LocationManagerMock()
        locationManagerMock.mockLocation = CLLocation(latitude: 0.4, longitude: 0.4)
        presenter.locationManager(locationManagerMock, didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)])

        // When
        presenter.didSelectTab(index: SelectedTabType.map.rawValue)

        // Then
        XCTAssert(routerMock.showRestaurantsMapCalled)
        XCTAssertEqual(routerMock.model, restaurantInfoModel)
    }

    func testListTabSelected() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        getRestaurantsUseCaseMock.result = .success(restaurantInfoModel)
        let locationManagerMock = LocationManagerMock()
        locationManagerMock.mockLocation = CLLocation(latitude: 0.4, longitude: 0.4)
        presenter.locationManager(locationManagerMock, didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)])

        // When
        presenter.didSelectTab(index: SelectedTabType.map.rawValue)
        presenter.didSelectTab(index: SelectedTabType.list.rawValue)

        // Then
        XCTAssert(routerMock.showRestaurantsListCalled)
        XCTAssertEqual(routerMock.model, restaurantInfoModel)
    }
}

final class LocationManagerMock: CLLocationManager {
    var mockLocation: CLLocation?
    var mockAuthorizationStatus: CLAuthorizationStatus?

    override var authorizationStatus: CLAuthorizationStatus {
        return mockAuthorizationStatus ?? .authorizedAlways
    }

    override var location: CLLocation? {
        return mockLocation
    }
}
