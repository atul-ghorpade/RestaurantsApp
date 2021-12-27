import Foundation

struct GetRestaurantImageDataParams {
    typealias Completion = (Result<Data, UseCaseError>) -> Void

    let imageReference: String
    let completion: Completion
}

protocol GetRestaurantImageDataUseCaseProtocol {
    func run(_ params: GetRestaurantImageDataParams)
}

final class GetRestaurantImageDataUseCase: GetRestaurantImageDataUseCaseProtocol {
    private let provider: RestaurantsProviderProtocol!

    init(provider: RestaurantsProviderProtocol) {
        self.provider = provider
    }

    func run(_ params: GetRestaurantImageDataParams) {
        provider.getRestaurantImageData(imageReference: params.imageReference) { result in
            params.completion(result)
        }
    }
}
