//

@testable import Restaurants

import XCTest

class RestaurantsListPresenterTests: XCTestCase {
    private var presenter: RestaurantsListPresenter!
    private var viewMock: RestaurantsListViewMock!
    private var routerMock: RestaurantsListRouterMock!
    private var delegateMock: RestaurantsListPresenterDelegateMock!

    override func setUp() {
        super.setUp()
        viewMock = RestaurantsListViewMock()
        delegateMock = RestaurantsListPresenterDelegateMock()
        routerMock = RestaurantsListRouterMock()
        presenter = RestaurantsListPresenter(view: viewMock,
                                             router: routerMock,
                                             delegate: delegateMock)

    }

    func testViewStateAfterSetModels() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)

        // When
        presenter.setRestaurantsInfoModel(restaurantInfoModel)

        // Then
        XCTAssertEqual(viewMock.viewState, .render)
    }

    func testNumberOfRowsInSection() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)

        // When
        presenter.setRestaurantsInfoModel(restaurantInfoModel)
        let numberOfRows = presenter.numberOfRowsInSection(section: 0)

        // Then
        XCTAssertEqual(numberOfRows, 1)
    }

    func testCellViewModel() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)

        // When
        presenter.setRestaurantsInfoModel(restaurantInfoModel)

        // Then
        guard let cellViewModel = presenter.viewModelForCell(at: IndexPath(row: 0, section: 0)) as? RestaurantCellViewModel else {
            return XCTFail("cellViewModel is not correct")
        }
        XCTAssertEqual(cellViewModel.name, "Restaurant Sample Name")
        XCTAssertEqual(cellViewModel.status, "Open")
        XCTAssertEqual(cellViewModel.imageURL, URL(string: "https://abc.com")!)
    }

    func testDidScrollBeyondCurrentPageWhenNextPageAvailable() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: "123")
        presenter.setRestaurantsInfoModel(restaurantInfoModel)

        // When
        presenter.didScrollBeyondCurrentPage()

        // Then
        XCTAssert(delegateMock.handleNextPageRequestCalled)
    }

    func testDidScrollBeyondCurrentPageWhenNextPageNotAvailable() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        presenter.setRestaurantsInfoModel(restaurantInfoModel)

        // When
        presenter.didScrollBeyondCurrentPage()

        // Then
        XCTAssertFalse(delegateMock.handleNextPageRequestCalled)
    }

    func testDidSelectRow() {
        // Given
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        presenter.setRestaurantsInfoModel(restaurantInfoModel)

        // When
        presenter.didSelectRow(indexPath: IndexPath(row: 0, section: 0))

        // Then
        XCTAssert(routerMock.showRestaurantsDetailsCalled)
        XCTAssertEqual(routerMock.model, restaurantModel)
    }
}

final class RestaurantsListPresenterDelegateMock: RestaurantsListPresenterDelegate {
    var handleNextPageRequestCalled = false

    func handleNextPageRequest() {
        handleNextPageRequestCalled = true
    }
}
