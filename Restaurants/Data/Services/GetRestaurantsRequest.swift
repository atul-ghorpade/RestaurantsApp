//

import Foundation

enum RestaurantsService {
    case restaurantsList(latitude: Double, longitude: Double)
    case restaurantsListForNextPage(nextPageInfo: String)
    case restaurantImageData(reference: String)
}

extension RestaurantsService: Request {
    var type: RequestType {
        .get
    }

    var path: String {
        switch self {
        case .restaurantsList, .restaurantsListForNextPage:
            return "/maps/api/place/nearbysearch/json"
        case .restaurantImageData:
            return "/maps/api/place/photo"
        }
    }

    var params: [String: Any]? {
        switch self {
        case .restaurantsList(let latitude, let longitude):
            return ["location": "\(latitude),\(longitude)",
                    "radius" : NetworkServiceConstants.nearbyRadius,
                    "types" : "restaurant"]
        case .restaurantsListForNextPage(let nextPageInfo):
            return ["pagetoken" : nextPageInfo]
        case .restaurantImageData(let reference):
            return ["photo_reference": reference,
                    "maxheight": 300]
        }
    }
}
