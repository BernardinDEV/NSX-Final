//
//  Api.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//


import Foundation
import Alamofire

protocol NetworkAuthServiceProtocol {
    func buildHeaders() -> HTTPHeaders
}

class NetworkAuthService: NetworkAuthServiceProtocol {

    func buildHeaders() -> HTTPHeaders {
        return [
            "Authorization": "Client-ID 1ceddedc03a5d71",
            "Content-Type": "application/json"
        ]
    }
}
