//

import Foundation

struct RestaurantsInfoResponseEntity: Decodable {
    let restaurants: [RestaurantEntity]
    let nextPageInfo: String?

    enum CodingKeys: String, CodingKey {
        case restaurants = "results"
        case nextPageInfo = "next_page_token"
    }

    func toDomain() throws -> RestaurantsInfoModel {
        let restaurantsModels = try restaurants.map {
            try $0.toDomain()
        }
        return RestaurantsInfoModel(restaurantsModels: restaurantsModels,
                                    nextPageInfo: nextPageInfo)
    }

}
