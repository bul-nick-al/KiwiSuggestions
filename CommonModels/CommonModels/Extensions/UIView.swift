//
//  UIView.swift
//  CommonModels
//
//  Created by Николай Булдаков on 01.06.2021.
//

import UIKit

extension UIView {
    public var frameInParentCoordinates: CGRect {
        superview?.convert(frame, to: nil) ?? frame
    }
}
