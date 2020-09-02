//
//  Extensions.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 24.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension CALayer {
    func shadow() {
        shadowColor = UIColor.darkGray.cgColor
        shadowOffset = CGSize(width: 0, height: 2)
        shadowRadius = 3
        shadowOpacity = 0.9
    }
}


extension UILabel {
    func set(_ text: String) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "globe")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        attachment.bounds = CGRect(x: -5, y: -0, width: 10, height: 10)
        let attachmentString = NSAttributedString(attachment: attachment)

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)

        let textString = NSAttributedString(string: text)
        mutableAttributedString.append(textString)

        self.attributedText = mutableAttributedString
    }
}
