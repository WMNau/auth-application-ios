//
//  RoundedButton+Button.swift
//  App Authorization
//
//  Created by Mike on 12/19/18.
//  Copyright © 2018 William Nau. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
