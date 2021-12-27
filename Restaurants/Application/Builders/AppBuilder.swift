//

import Foundation

final class AppBuilder {
    func buildRestaurantsParent() -> RestaurantsParentBuilder  {
        return RestaurantsParentBuilder()
    }
}
