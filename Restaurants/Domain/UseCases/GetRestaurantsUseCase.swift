struct GetRestaurantsParams {
    typealias Completion = (Result<RestaurantsInfoModel, UseCaseError>) -> Void

    let location: LocationModel
    let nextPageInfo: String?
    let completion: Completion
}

protocol GetRestaurantsUseCaseProtocol {
    func run(_ params: GetRestaurantsParams)
}

final class GetRestaurantsUseCase: GetRestaurantsUseCaseProtocol {
    private let provider: RestaurantsProviderProtocol!

    init(provider: RestaurantsProviderProtocol) {
        self.provider = provider
    }

    func run(_ params: GetRestaurantsParams) {
        provider.getRestaurantsList(location: params.location,
                                    nextPageInfo: params.nextPageInfo) { result in
            params.completion(result)
        }
    }
}
