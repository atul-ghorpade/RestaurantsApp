//
//  DecodableParentEntityProtocol.swift
//  Restaurants
//
//  Created by Atul Ghorpade on 28/12/21.
//

protocol DecodableParentEntityProtocol: Decodable {
    var status: Status? { get }
}

enum Status: String, Decodable { // Used for Response Code 200 specific internal statuses
    case success = "OK"
    case requestDenied = "REQUEST_DENIED"
    case invalidRequest = "INVALID_REQUEST"
}
