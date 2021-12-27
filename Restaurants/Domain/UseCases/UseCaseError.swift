enum UseCaseError: Error {
    case mapping(Swift.Error)
    case underlying(Swift.Error)
    case network(NetworkError)
}

enum NetworkError: Error {
    case api(APIError)
    case timeout(Swift.Error)
    case generic(Swift.Error)
    case noConnection(Swift.Error)
}

enum APIError {
    case error500(Swift.Error)
}
