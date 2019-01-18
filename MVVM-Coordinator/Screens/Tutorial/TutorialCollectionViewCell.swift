//
//  TutorialCollectionViewCell.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/18/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxCocoa

class TutorialCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var tutorialImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(imageString: String, color: UIColor) {
        self.backgroundColor = color
        self.tutorialImage.image = UIImage(named: imageString)
    }
}
