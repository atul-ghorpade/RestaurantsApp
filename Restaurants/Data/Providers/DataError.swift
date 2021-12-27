enum DataError: Error {
    case apiFailure
    case apiInvalid
    case parseFail
    case networkError
    case unknown
}
