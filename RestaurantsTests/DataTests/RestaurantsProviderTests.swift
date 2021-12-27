//

import XCTest

@testable import Restaurants

class RestaurantsProviderTests: XCTestCase {
    var provider: RestaurantsProvider!
    let networkServiceMock = NetworkServiceMock()

    override func setUp() {
        super.setUp()
        provider = RestaurantsProvider(networkService: networkServiceMock)
    }

    func testGetRestaurantsListSuccess() {
        // Given
        let data = getDataFromJSONFile(fileName: "GetRestaurantsList")
        networkServiceMock.result = .success(data)

        // THen
        let expectation = expectation(description: "Get Restaurants parse success")
        provider.getRestaurantsList(location: getSampleLocationModel(),
                                    nextPageInfo: nil) { result in
            if case let .success(response) = result {
                XCTAssertEqual(response.restaurantsModels.count, 20)
                XCTAssertEqual(self.networkServiceMock.request?.type,
                               .get)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetRestaurantsListMappingError() {
        // Given
        networkServiceMock.result = .success(Data([]))

        // THen
        let expectation = expectation(description: "Get Restaurants parse fsilure")
        provider.getRestaurantsList(location: getSampleLocationModel(),
                                    nextPageInfo: nil) { result in
            if case .failure(.mapping) = result {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetRestaurantsListAPIError() {
        // Given
        networkServiceMock.result = .failure(.networkError)

        // THen
        let expectation = expectation(description: "Get Restaurants generic error")
        provider.getRestaurantsList(location: getSampleLocationModel(),
                                    nextPageInfo: nil) { result in
            if case .failure(.network) = result {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}

extension RestaurantsProviderTests {
    private func getDataFromJSONFile(fileName: String) -> Data {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            fatalError("JSON file \(fileName) not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("cannot convert JSON to string")
        }

        guard let data = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert to Data")
        }

        return data
    }

    private func getSampleLocationModel() -> LocationModel {
        LocationModel(latitude: 0, longitude: 0)
    }
}
