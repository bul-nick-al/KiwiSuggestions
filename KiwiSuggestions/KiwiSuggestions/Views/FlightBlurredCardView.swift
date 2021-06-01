//
//  FlightBlurredCardView.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 31.05.2021.
//

import CommonModels
import UIKit

class FlightBlurredCardView: NiblessView {
    lazy var flightCardView = FlightCardView()

    let label: UILabel = {
        let label = UILabel()

        label.text = "See more details"
        label.font = .preferredFont(forTextStyle: .caption1)

        return label
    }()

    lazy var seeDetailsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            UIImageView(image: .init(systemName: "chevron.up")), label
        ])

        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center

        return stack
    }()

    override init() {
        super.init()

        let blurredCard = BlurredCardView()
        blurredCard.layer.masksToBounds = true
        blurredCard.layer.cornerRadius = 20
        addSubview(blurredCard)
        blurredCard.edgesToSuperview()
        blurredCard.layoutMargins = .init(top: 16, left: 24, bottom: 16, right: 24)
        blurredCard.addSubview(flightCardView)
        blurredCard.addSubview(seeDetailsStack)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .prominent))
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        vibrancyEffectView.contentView.addSubview(seeDetailsStack)
        blurredCard.effectView.contentView.addSubview(vibrancyEffectView)
        seeDetailsStack.edgesToSuperview()
        vibrancyEffectView.edges(to: blurredCard.layoutMarginsGuide, excluding: .top)
        flightCardView.edges(to: blurredCard.layoutMarginsGuide, excluding: .bottom)

        vibrancyEffectView.topToBottom(of: flightCardView, offset: 8)
    }
}
