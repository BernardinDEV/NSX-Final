//
//  NSX.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//
import Foundation

protocol NsxServiceProtocol {
    func directLink() -> String
    func directExtension() -> String
    func directLink(to cover: String) -> String
}

class NsxService: NsxServiceProtocol {

    func directLink() -> String {
        return "https://i.imgur.com/"
    }

    func directExtension() -> String {
        return ".jpg"
    }

    func directLink(to cover: String) -> String {
        return "\(self.directLink())\(cover)\(self.directExtension())"
    }

}
