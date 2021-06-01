//
//  NiblessView.swift
//  CommonModels
//
//  Created by Николай Булдаков on 31.05.2021.
//

import UIKit

open class NiblessView: UIView {

    public init() {
        super.init(frame: CGRect.zero)
    }

    @available(
        *,
        unavailable,
        message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )

    required public init?(coder: NSCoder) {
        fatalError(
            "Loading this view from a nib is unsupported in favor of initializer dependency injection."
        )
    }
}
