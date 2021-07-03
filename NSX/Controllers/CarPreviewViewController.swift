//
//  File.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import UIKit

class CarPreviewViewController: UIViewController {

    private let pictureView = UIImageView()

    override func loadView() {
        self.pictureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view = self.pictureView
    }

    init(picture: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.pictureView.image = picture
        self.preferredContentSize = picture.size
    }

    required init?(coder: NSCoder) {
      fatalError("Error")
    }
}
