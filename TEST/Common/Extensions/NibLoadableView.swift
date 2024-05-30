//
//  NibLoadableView.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import Foundation
import UIKit

protocol NibLoadableView {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
