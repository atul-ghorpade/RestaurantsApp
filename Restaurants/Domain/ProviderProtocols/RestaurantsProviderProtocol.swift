import Foundation

protocol RestaurantsProviderProtocol {
    typealias RestaurantsListCompletion = (Result<RestaurantsInfoModel, UseCaseError>) -> Void
    typealias RestaurantImageDataCompletion = (Result<Data, UseCaseError>) -> Void

    func getRestaurantsList(location: LocationModel,
                            nextPageInfo: String?,
                            completion: @escaping RestaurantsListCompletion)
    func getRestaurantImageData(imageReference: String,
                                completion: @escaping RestaurantImageDataCompletion)
}
