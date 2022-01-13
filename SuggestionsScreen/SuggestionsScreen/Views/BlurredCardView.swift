//
//  BlurredCardView.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 31.05.2021.
//

import UIKit
import CommonModels

class BlurredCardView: NiblessView {

    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))

    public override init() {
        super.init()

        addSubview(effectView)
        effectView.edgesToSuperview()
    }
}
