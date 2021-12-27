import Foundation
@testable import Restaurants

final class GetRestaurantsUseCaseMock: GetRestaurantsUseCaseProtocol {
    var result: Result<RestaurantsInfoModel, UseCaseError>?

    func run(_ params: GetRestaurantsParams) {
        guard let result = result else {
            fatalError("Result not provided to mock")
        }
        params.completion(result)
    }
}
