//
//  UIFont+Extension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import UIKit

extension UIButton {
    public func setup(title: String = "",
               backgroundColor: UIColor,
               textColor: UIColor = .white,
               font: UIFont,
               state: State = .normal){
        self.setTitle(title, for: state)
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: state)
        self.titleLabel?.font = font
    }

    public func rounded(radiusValue: CGFloat = 25) {
        self.layer.cornerRadius = radiusValue
        self.layer.masksToBounds = false
    }

    public func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}

extension UILabel {
    public func setup(title: String = "",
               textColor: UIColor = .white,
               font: UIFont,
               aligment: NSTextAlignment = .center) {
        self.text = title
        self.textColor = textColor
        self.font = font
    }

    public func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer,
                                                 fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension UITextField {
    public func setup(textColor: UIColor = .white,
               font: UIFont,
               placeHolderText: String,
               aligment: NSTextAlignment = .center) {
        self.font = font
        self.placeholder = placeHolderText
        self.textColor = textColor
        self.textAlignment = aligment
    }

    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        leftView = imageView
        leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        leftViewMode = .always
    }
}
