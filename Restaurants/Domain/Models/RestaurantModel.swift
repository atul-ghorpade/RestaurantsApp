//

import Foundation

struct RestaurantModel: Equatable {
    let name: String
    let imageURL: URL?
    let openStatus: Bool?
    let locationModel: LocationModel
    let address: String?
    let photoReference: String?
}

struct LocationModel: Equatable {
    let latitude: Double
    let longitude: Double
}
