//
//  FlightSuggestionsViewController.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 25.05.2021.
//

import UIKit
import TinyConstraints
import CommonModels
import Suggestions
import Storage
import API
import CoreLocation
import Location

class FlightSuggestionsViewController: NiblessViewController {

    // MARK: - Properties

    var selectedIndexPath: IndexPath?

    // MARK: Dependencies

    private let locationProvider: CurrentLocationProvider
    private let suggestionService: SuggestionsService
    private let locationManager: LocationService

    // MARK: - Data

    private var flights: [Flight] = []
    private var images: [String: UIImage?] = [:]

    // MARK: - Constants & computed values

    private var itemSize: CGSize { .init(width: view.frame.width * itemWidthMultiplier, height: 450) }
    private var sectionSpacing: CGFloat { view.frame.width / 13 }
    private let itemWidthMultiplier: CGFloat = 0.75

    // MARK: Cell indentifier

    private let cellIdentifier = "Cell"

    // MARK: Transition delegate

    private let transitionDelegate = CardTransitionDelegate()

    // MARK: Typealias

    typealias FlightCardCollectionView = ContainerCollectionCell<FlightBlurredCardView>

    // MARK: UI

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder")

        return imageView
    }()

    private lazy var loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView()

        loaderView.hidesWhenStopped = true

        return loaderView
    }()

    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = ZoomFlowLayout(itemHeight: itemSize.height, itemWidthMultiplier: itemWidthMultiplier)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(FlightCardCollectionView.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    // MARK: - Init

    public init(
        locationProvider: CurrentLocationProvider,
        suggestionService: SuggestionsService,
        locationManager: LocationService
    ) {
        self.locationProvider = locationProvider
        self.suggestionService = suggestionService
        self.locationManager = locationManager

        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        view.addSubview(collectionView)
        view.addSubview(loaderView)

        loaderView.style = .large

        loaderView.centerInSuperview()
        imageView.edgesToSuperview()
        collectionView.edgesToSuperview()

        start()
    }

    private func start() {
        loaderView.startAnimating()

        if suggestionService.hasCachedSuggestions { getFlightSuggestions() }
        else { locationManager.getLocation { [weak self] in
            switch $0 {
            case .success(let location):
                self?.locationProvider.location = location
            case .failure:
                ()
            }

            self?.getFlightSuggestions()
        } }
    }

    private func getFlightSuggestions() {
        suggestionService.getFlightSuggestions { [weak self] in
            switch $0 {
            case .success(let success):
                self?.loaderView.stopAnimating()
                DispatchQueue.main.async {
                    self?.flights = success.suggestedFlights
                    self?.images = success.destinationImages
                        .mapValues { UIImage(data: $0)?.blurImage(radius: 2) ?? UIImage(named: "placeholder")! }
                    self?.collectionView.reloadData()
                    self?.setBackgroundImage()
                }
            case .failure(let error):
                let alert = UIAlertController(
                    title: "Loading error", message: error.localizedDescription, preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func setBackgroundImage() {
        guard flights.count > 0 else { return }

        let totalListWidth = itemSize.width * CGFloat(flights.count) + sectionSpacing * CGFloat(flights.count - 1)

        let currentScrollPercentageRaw = (collectionView.contentOffset.x + itemSize.width / 2) / totalListWidth
        let currentScrollPercentage = min(max(currentScrollPercentageRaw, 0), 1)
        let focusedItemIndex = Int((currentScrollPercentage * CGFloat(images.count)).rounded(.down))

        guard
            flights.count > focusedItemIndex, focusedItemIndex >= 0,
            let mapIdto = flights[focusedItemIndex].mapIdto,
            let image = images[mapIdto]
        else {
            UIView.transition(
                with: imageView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { self.imageView.image = UIImage(named: "placeholder") }
            )

            return
        }

        guard imageView.image != image else {
            return
        }

        UIView.transition(
            with: imageView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { self.imageView.image = image }
        )
    }

}

extension FlightSuggestionsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flights.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        itemSize
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            as? FlightCardCollectionView ?? FlightCardCollectionView()

        cell.child?.flightCardView.configure(with: flights[indexPath.item])
        cell.child?.flightCardView.cityFromTitledLabel.isHidden = true
        cell.child?.flightCardView.hasAirportChange.isHidden = true

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        sectionSpacing
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setBackgroundImage()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath

        let viewController = FlightFullDetailsViewController()
        viewController.transitioningDelegate = transitionDelegate
        viewController.configure(with: flights[indexPath.item])
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true, completion: nil)
    }
}
