//

import Foundation

struct RestaurantEntity: Decodable {
    let name: String
    let iconString: String?
    let openingHours: OpeningHoursEntity?
    let geometry: GeometryEntity?
    let address: String?
    let photos: [PhotoEntity]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case iconString = "icon"
        case openingHours = "opening_hours"
        case geometry = "geometry"
        case address = "vicinity"
        case photos = "photos"
    }

    func toDomain() throws -> RestaurantModel {
        guard let latitude = geometry?.location.latitude,
              let longitude = geometry?.location.longitude else {
            let error = EncodingError.Context(codingPath: [RestaurantEntity.CodingKeys.geometry],
                                              debugDescription: "invalid location")
            throw EncodingError.invalidValue(self, error)
        }

        let location = LocationModel(latitude: latitude,
                                     longitude: longitude)
        let imageURL = URL(string: iconString ?? "")
        let openStatus = openingHours?.isOpenedNow

        return RestaurantModel(name: name,
                               imageURL: imageURL,
                               openStatus: openStatus,
                               locationModel: location,
                               address: address,
                               photoReference: photos?.first?.photoReference)
    }
}

struct OpeningHoursEntity: Decodable {
    let isOpenedNow: Bool

    enum CodingKeys: String, CodingKey {
        case isOpenedNow = "open_now"
    }
}

struct GeometryEntity: Decodable {
    let location: LocationEntity
}

struct LocationEntity: Decodable {
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct PhotoEntity: Decodable {
    let photoReference: String

    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
