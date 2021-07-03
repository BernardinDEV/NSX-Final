//
//  Image.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import Alamofire
import AlamofireImage

protocol ImageServiceProtocol {
    func downloadImage(from url: String, completion: @escaping (AFDataResponse<Image>) -> Void)
}

class ImageService: ImageServiceProtocol {
    // MARK: Methods
    func downloadImage(from url: String, completion: @escaping (AFDataResponse<Image>) -> Void) {
        AF.request(url).responseImage(completionHandler: completion)
    }
}
