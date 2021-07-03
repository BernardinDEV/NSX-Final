//
//  CarCollectionViewCell.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import UIKit
import SkeletonView

class CarCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var picture: UIImageView!

    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        self.picture.image = nil
    }

    func setPicture(_ picture: UIImage?) {
        picture == nil ? self.picture.showAnimatedSkeleton() : self.picture.hideSkeleton()
        self.picture.contentMode = .scaleAspectFill
        self.picture.image = picture
    }
}
