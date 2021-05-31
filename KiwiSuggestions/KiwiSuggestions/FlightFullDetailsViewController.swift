//
//  FlightFullDetailsViewController.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 30.05.2021.
//

import UIKit

class FlightFullDetailsView: NiblessView {

    let flightCardView = FlightCardView()
    override init() {
        super.init()

        addSubview(flightCardView)

        flightCardView.edges(to: layoutMarginsGuide)
    }
}

class FlightFullDetailsViewController: BaseBoundViewController<Void, Void, FlightFullDetailsView> {
    override func setupView() {
        boundView.flightCardView.departureTitledLabel.titleLabel.text = "LAS"
        boundView.flightCardView.departureTitledLabel.subtitleLabel.text = "24 Apr, 16:30"
        boundView.flightCardView.destinationTitledLabel.titleLabel.text = "NYC"
        boundView.flightCardView.destinationTitledLabel.subtitleLabel.text = "20:45"
        boundView.flightCardView.flightDurationTitledLabel.titleLabel.text = "Duration"
        boundView.flightCardView.flightDurationTitledLabel.subtitleLabel.text = "2h"
        boundView.flightCardView.seatsAvailableTitledLabel.titleLabel.text = "Seats"
        boundView.flightCardView.seatsAvailableTitledLabel.subtitleLabel.text = "45"
        boundView.flightCardView.flightNumberTitledLabel.titleLabel.text = "Flight №"
        boundView.flightCardView.flightNumberTitledLabel.subtitleLabel.text = "2345"
        boundView.flightCardView.totalPriceTitledLabel.titleLabel.text = "Price you will pay"
        boundView.flightCardView.totalPriceTitledLabel.subtitleLabel.text = "30 eur"
        boundView.flightCardView.cityToTitledLabel.titleLabel.text = "Destination"
        boundView.flightCardView.cityToTitledLabel.subtitleLabel.text = "Barcelona, Spain"

        view.backgroundColor = .systemBackground
        view.layoutMargins = .init(top: 24, left: 16, bottom: 24, right: 16)
    }

    override func bindViewModel() {
    }
}
