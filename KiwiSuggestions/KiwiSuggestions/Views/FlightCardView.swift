//
//  FlightCardView.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 31.05.2021.
//

import UIKit
import CommonModels

class FlightCardView: NiblessView {

    lazy var departureTitledLabel: TitledLabel = .init(
        titleColor: .label,
        titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
        subtitleColor: .secondaryLabel,
        subtitleFont: UIFont.preferredFont(forTextStyle: .caption1)
    )

    let chevronImageView: UIImageView = .init(
        image: .init(systemName: "chevron.right")?.withTintColor(.systemBackground)
    )

    let destinationTitledLabel: TitledLabel = .init(
        titleColor: .label,
        titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
        subtitleColor: .secondaryLabel,
        subtitleFont: UIFont.preferredFont(forTextStyle: .caption1)
    )

    lazy var topContainer: UIView = {
        let container = UIView()

        container.addSubview(departureTitledLabel)
        container.addSubview(chevronImageView)
        container.addSubview(destinationTitledLabel)

        departureTitledLabel.edgesToSuperview(excluding: .trailing)
        chevronImageView.centerXToSuperview()
        chevronImageView.centerY(to: departureTitledLabel.titleLabel)
        destinationTitledLabel.edgesToSuperview(excluding: .leading)

        return container
    }()

    let planeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "plane"))

        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let flightDurationTitledLabel: TitledLabel = .init(
        titleColor: .tertiaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .body)
    )

    let seatsAvailableTitledLabel: TitledLabel = .init(
        titleColor: .tertiaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .body)
    )

    let flightNumberTitledLabel: TitledLabel = .init(
        titleColor: .tertiaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .body)
    )

    lazy var flightDetailsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            flightDurationTitledLabel, seatsAvailableTitledLabel, flightNumberTitledLabel
        ])

        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually

        return stack
    }()

    let cityFromTitledLabel: TitledLabel = .init(
        titleColor: .tertiaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .body)
    )

    let cityToTitledLabel: TitledLabel = .init(
        titleColor: .tertiaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .body)
    )

    let hasAirportChange: TitledLabel = .init(
        titleColor: .tertiaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .body)
    )

    let totalPriceTitledLabel: TitledLabel = .init(
        titleColor: .secondaryLabel,
        titleFont: UIFont.preferredFont(forTextStyle: .caption1),
        subtitleColor: .label,
        subtitleFont: UIFont.preferredFont(forTextStyle: .title1)
    )

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topContainer,
            planeImageView,
            flightDetailsStack,
            cityFromTitledLabel,
            cityToTitledLabel,
            hasAirportChange
        ])

        stack.axis = .vertical
        stack.spacing = 16

        return stack
    }()

    override init() {
        super.init()

        addSubview(stack)

        destinationTitledLabel.titleLabel.textAlignment = .right
        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.height(chevronImageView.image!.size.height)

        stack.edges(to: layoutMarginsGuide, excluding: .bottom)
        addSubview(totalPriceTitledLabel)
        totalPriceTitledLabel.edges(to: layoutMarginsGuide, excluding: .top)
        planeImageView.height(80)

        totalPriceTitledLabel.topToBottom(of: stack, offset: 16, relation: .equalOrGreater)
    }
}

extension FlightCardView: Configurable {
    typealias ConfigurationModel = Flight

    func configure(with flight: Flight) {
        departureTitledLabel.titleLabel.text = flight.flyFrom
        departureTitledLabel.subtitleLabel.text = flight.dTimeUTC
            .map(Double.init)
            .map(Date.init(timeIntervalSince1970:))?
            .asDateTimeString(dateStyle: .short, timeStyle: .short)
        destinationTitledLabel.titleLabel.text = flight.flyTo
        destinationTitledLabel.subtitleLabel.text = flight.aTimeUTC
            .map(Double.init)
            .map(Date.init(timeIntervalSince1970:))?
            .asDateTimeString(dateStyle: .short, timeStyle: .short)
        flightDurationTitledLabel.titleLabel.text = "Duration"
        flightDurationTitledLabel.subtitleLabel.text = flight.flyDuration ?? "-"
        seatsAvailableTitledLabel.titleLabel.text = "Seats"
        seatsAvailableTitledLabel.subtitleLabel.text = flight.availability?.seats.map { "\($0)" } ?? "-"
        flightNumberTitledLabel.titleLabel.text = "Flight №"
        flightNumberTitledLabel.subtitleLabel.text = flight.route?.first.map { "\($0.airline ?? "")\($0.flightNo ?? 0)" }
        totalPriceTitledLabel.titleLabel.text = "Price you will pay"
        totalPriceTitledLabel.subtitleLabel.text = flight.conversion?.first.map { "\($0.value) \($0.key)" }
        cityFromTitledLabel.titleLabel.text = "Departure from"
        cityFromTitledLabel.subtitleLabel.text = "\(flight.cityFrom ?? ""), \(flight.countryFrom?.name ?? "")"
        cityToTitledLabel.titleLabel.text = "Destination"
        cityToTitledLabel.subtitleLabel.text = "\(flight.cityTo ?? ""), \(flight.countryTo?.name ?? "")"
        hasAirportChange.titleLabel.text = "Has airport change"
        hasAirportChange.subtitleLabel.text = flight.hasAirportChange ?? false ? "Yes" : "No"

    }
}
