//

import Foundation
import MapKit

final class RestaurantAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?

    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
