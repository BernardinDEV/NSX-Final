//
//  Nsx.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
struct Nsx: Codable, MenuIdentifiable {
    // MARK: Properties
    var id: String
    var title: String
    var cover: String?
    var coverWidth: Double?
    var coverHeight: Double?
    var link: String

  var nsxService: NsxServiceProtocol = NsxService()

    // MARK: Methods
    func directLink()-> String {
        if let cover = self.cover {
            return self.nsxService.directLink(to: cover)
        }

        return self.link
    }

    mutating func setNsxService(_ NsxService: NsxServiceProtocol) {
        self.nsxService = NsxService
    }

    // MARK: Keys
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
        case coverWidth = "cover_width"
        case coverHeight = "cover_height"
        case link
    }
}
