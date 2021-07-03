//
//  Request.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import Alamofire

enum NetworkUrlType: String {
    case nsx
}

protocol NetworkServiceProtocol {
    func fetchNsx(page: Int, completion: @escaping (DataResponse<NsxResult, AFError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {

    // MARK: Properties
    fileprivate let baseURL = "https://api.imgur.com/3/gallery/search/time/all"
    var networkAuthService: NetworkAuthServiceProtocol

    // MARK: Initializers
    init(networkAuthService: NetworkAuthServiceProtocol = NetworkAuthService()) {
        self.networkAuthService = networkAuthService
    }

    // MARK: Methods
    private func buildSearchURL(page: Int, type: NetworkUrlType) -> URL {
        return URL(string: "\(self.baseURL)/\(page)?q=\(type.rawValue)")!
    }

    func fetchNsx(page: Int = 0, completion: @escaping (DataResponse<NsxResult, AFError>) -> Void) {
      AF.request(self.buildSearchURL(page: page, type: .nsx), headers: self.networkAuthService.buildHeaders())
            .responseDecodable(of: NsxResult.self, completionHandler: completion)

    }
}
