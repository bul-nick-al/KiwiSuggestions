//
//  TitledLabel.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 31.05.2021.
//

import CommonModels
import UIKit

class TitledLabel: NiblessView {
    public private(set) lazy var titleLabel: UILabel = UILabel()
    public private(set) lazy var subtitleLabel: UILabel = UILabel()
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])

        stack.axis = .vertical

        return stack
    }()

    override init() {
        super.init()

        addSubview(stack)
        stack.edgesToSuperview()
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.adjustsFontSizeToFitWidth = true
    }

    convenience init(
        titleText: String? = nil, titleColor: UIColor? = nil, titleFont: UIFont? = nil,
        subtitleText: String? = nil, subtitleColor: UIColor? = nil, subtitleFont: UIFont? = nil
    ) {
        self.init()

        titleLabel.text = titleText
        if let titleColor = titleColor { titleLabel.textColor = titleColor }
        if let titleFont = titleFont { titleLabel.font = titleFont }

        subtitleLabel.text = subtitleText
        if let subtitleColor = subtitleColor { subtitleLabel.textColor = subtitleColor }
        if let subtitleFont = subtitleFont { subtitleLabel.font = subtitleFont }
    }
}
