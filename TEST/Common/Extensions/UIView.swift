//
//  UIView.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import UIKit

public extension UIView {
    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
