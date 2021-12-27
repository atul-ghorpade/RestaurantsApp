//

import Foundation

final class RestaurantsProvider: RestaurantsProviderProtocol {
    private var networkService: NetworkServiceProtocol = NetworkService()

    convenience init(networkService: NetworkServiceProtocol) {
        self.init()
        self.networkService = networkService
    }

    func getRestaurantsList(location: LocationModel,
                            nextPageInfo: String?,
                            completion: @escaping RestaurantsListCompletion) {
        var request: Request
        if let nextPageInfo = nextPageInfo {
            request = RestaurantsService.restaurantsListForNextPage(nextPageInfo: nextPageInfo)
        } else {
            request = RestaurantsService.restaurantsList(latitude: location.latitude,
                                                         longitude: location.longitude)
        }

        networkService.processRequest(request: request) { result in
            switch result {
            case let .success(data):
                do {
                    let restaurantsInfoEntity = try JSONDecoder().decode(RestaurantsInfoResponseEntity.self, from: data)
                    let restaurantsInfoModel = try restaurantsInfoEntity.toDomain()
                    print("Number of Restaurants fetched: \(restaurantsInfoModel.restaurantsModels.count)")
                    completion(.success(restaurantsInfoModel))
                } catch {
                    completion(.failure(.mapping(error)))
                }
            case let .failure(error):
                completion(.failure(.network(.generic(error))))
            }
        }
    }

    func getRestaurantImageData(imageReference: String,
                                completion: @escaping RestaurantImageDataCompletion) {
        let request = RestaurantsService.restaurantImageData(reference: imageReference)
        networkService.processRequest(request: request) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(.network(.generic(error))))
            }
        }
    }
}
