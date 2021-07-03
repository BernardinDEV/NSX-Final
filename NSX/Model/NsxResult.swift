//
//  NsxResult.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
struct NsxResult: Codable {
    var data: [Nsx]
    var success: Bool
    var status: Int
}
