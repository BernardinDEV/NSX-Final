//
//  NsxDetatilViewModel.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//
import Foundation
import RxSwift
import RxCocoa

class NsxDetailViewModel {
    // MARK: Properties
    let nsx: Nsx
    let picture: UIImage

    // MARK: Initializers
    init(nsx: Nsx, picture: UIImage) {
        self.nsx = nsx
        self.picture = picture
    }
}
