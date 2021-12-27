//

import XCTest

@testable import Restaurants

class GetRestaurantsUseCaseTests: XCTestCase {
    var useCase: GetRestaurantsUseCase!
    let providerMock = RestaurantsProviderMock()

    override func setUp() {
        super.setUp()
        useCase = GetRestaurantsUseCase(provider: providerMock)
    }

    func testGetRestaurantsSuccess() {
        let expectation = expectation(description: "Get Restaurants success")
        providerMock.restaurantsListResult = .success(getSampleRestaurantsInfoModel())
        useCase.run(GetRestaurantsParams(location: getSampleLocationModel(),
                                         nextPageInfo: "123") { result in
            if case let .success(response) = result {
                XCTAssertEqual(response.restaurantsModels.count, 1)
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetRestaurantsFailure() {
        let expectation = expectation(description: "Get Restaurants failure")
        let underlyingError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
        providerMock.restaurantsListResult = .failure(.underlying(underlyingError))
        useCase.run(GetRestaurantsParams(location: getSampleLocationModel(),
                                         nextPageInfo: "123") { result in
            if case .failure = result {
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }
}

extension GetRestaurantsUseCaseTests {
    private func getSampleRestaurantsInfoModel() -> RestaurantsInfoModel {
        let restaurantModel = RestaurantModel(name: "Restaurant Sample Name",
                                             imageURL: URL(string: "https://abc.com")!,
                                             openStatus: true,
                                             locationModel: LocationModel(latitude: 0.1, longitude: 0.1),
                                             address: "Restaurant Sample Address",
                                             photoReference: "photo123")
        let restaurantInfoModel = RestaurantsInfoModel(restaurantsModels: [restaurantModel],
                                                       nextPageInfo: nil)
        return restaurantInfoModel
    }

    private func getSampleLocationModel() -> LocationModel {
        LocationModel(latitude: 0, longitude: 0)
    }
}
