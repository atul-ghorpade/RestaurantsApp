import Foundation
@testable import Restaurants

final class RestaurantsProviderMock: RestaurantsProviderProtocol {
    var restaurantsListResult: Result<RestaurantsInfoModel, UseCaseError>?
    var restaurantImageDataResult: Result<Data, UseCaseError>?

    func getRestaurantsList(location: LocationModel,
                            nextPageInfo: String?,
                            completion: @escaping RestaurantsListCompletion) {
        guard let restaurantsListResult = restaurantsListResult else {
            fatalError("Result not provided")
        }
        completion(restaurantsListResult)
    }

    func getRestaurantImageData(imageReference: String,
                                completion: @escaping RestaurantImageDataCompletion) {
        guard let restaurantImageDataResult = restaurantImageDataResult else {
            fatalError("Result not provided")
        }
        completion(restaurantImageDataResult)
    }
}
