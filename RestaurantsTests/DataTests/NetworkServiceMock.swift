//

import Foundation
@testable import Restaurants

final class NetworkServiceMock: NetworkServiceProtocol {
    var request: Request?
    var result: Result<Data, DataError>?

    func processRequest(request: Request, completion: @escaping NetworkCompletion) {
        self.request = request
        guard let result = result else {
            fatalError("Result not provided to mock")
        }
        completion(result)
    }
}
