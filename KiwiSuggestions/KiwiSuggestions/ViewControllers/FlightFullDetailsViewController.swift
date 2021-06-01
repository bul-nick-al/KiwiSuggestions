//
//  FlightFullDetailsViewController.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 30.05.2021.
//

import UIKit
import CommonModels

class FlightFullDetailsView: NiblessView {

    let flightCardView = FlightCardView()
    lazy var seeFullButton: UIButton = {
        let button = UIButton()

        button.setTitle("See all details", for: .normal)
        button.setTitleColor(tintColor, for: .normal)

        return button
    }()

    let label: UILabel = {
        let label = UILabel()

        label.text = "Swipe down to close"
        label.font = .preferredFont(forTextStyle: .caption1)

        return label
    }()

    let imageView = UIImageView(image: .init(systemName: "chevron.down"))

    lazy var collapseStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            label, imageView
        ])

        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center

        return stack
    }()

    override init() {
        super.init()

        imageView.tintColor = label.textColor

        addSubview(collapseStack)
        addSubview(flightCardView)
        addSubview(seeFullButton)

        flightCardView.edges(to: layoutMarginsGuide, excluding: [.bottom])
        collapseStack.edges(to: layoutMarginsGuide,excluding: [.top])
        collapseStack.topToBottom(of: flightCardView, offset: 16)
        seeFullButton.edges(to: flightCardView, excluding: [.top, .left])
    }
}

class FlightFullDetailsViewController: BaseBoundViewController<FlightFullDetailsView> {
    fileprivate var linkToFullDetails: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.layoutMargins = .init(top: 24, left: 16, bottom: 8, right: 16)

        boundView.seeFullButton.addTarget(self, action: #selector(openDetails), for: .touchUpInside)
    }

    @objc private func openDetails() {
        guard let url = linkToFullDetails else { return }

        UIApplication.shared.open(url)
    }
}

extension FlightFullDetailsViewController: Configurable {
    typealias ConfigurationModel = Flight

    func configure(with flight: Flight) {
        boundView.flightCardView.configure(with: flight)

        if let deepLink = flight.deepLink, let url = URL(string: deepLink) {
            linkToFullDetails = url
            boundView.seeFullButton.isHidden = false
        } else {
            boundView.seeFullButton.isHidden = true
        }
    }
}
