//
//  ViewController.swift
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

    let cityToTitledLabel: TitledLabel = .init(
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

//    let totalPriceStack: TitledLabel

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topContainer, planeImageView, flightDetailsStack, cityToTitledLabel
        ])

        stack.axis = .vertical
        stack.spacing = 16

        return stack
    }()

    override init() {
        super.init()

        addSubview(stack)

        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.height(chevronImageView.image!.size.height)

        stack.edges(to: layoutMarginsGuide, excluding: .bottom)
        addSubview(totalPriceTitledLabel)
        totalPriceTitledLabel.edges(to: layoutMarginsGuide, excluding: .top)

        let imageSize = UIImage(named: "plane")!.size

        planeImageView.heightToWidth(of: self, multiplier: imageSize.height / imageSize.width)

        totalPriceTitledLabel.topToBottom(of: stack, offset: 16, relation: .equalOrGreater)
    }

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
}

extension FlightCardView: Configurable {
    typealias ConfigurationModel = Flight

    func configure(with flight: Flight) {
        departureTitledLabel.titleLabel.text = flight.flyFrom
        departureTitledLabel.subtitleLabel.text = flight.dTimeUTC.map(Double.init).map(Date.init(timeIntervalSince1970:))?.asDateTimeString(dateStyle: .short, timeStyle: .short)
        destinationTitledLabel.titleLabel.text = flight.flyTo
        destinationTitledLabel.subtitleLabel.text = flight.aTimeUTC.map(Double.init).map(Date.init(timeIntervalSince1970:))?.asDateTimeString(dateStyle: .short, timeStyle: .short)
        flightDurationTitledLabel.titleLabel.text = "Duration"
        flightDurationTitledLabel.subtitleLabel.text = flight.flyDuration ?? "-"
        seatsAvailableTitledLabel.titleLabel.text = "Seats"
        seatsAvailableTitledLabel.subtitleLabel.text = flight.availability?.seats.map { "\($0)" } ?? "-"
        flightNumberTitledLabel.titleLabel.text = "Flight №"
        flightNumberTitledLabel.subtitleLabel.text = "\(flight.route?.count ?? 0)"
        totalPriceTitledLabel.titleLabel.text = "Price you will pay"
        totalPriceTitledLabel.subtitleLabel.text = flight.conversion?.first.map { "\($0.value) \($0.key)" }
        cityToTitledLabel.titleLabel.text = "Destination"
        cityToTitledLabel.subtitleLabel.text = "\(flight.cityTo ?? ""), \(flight.countryTo?.name ?? "")"
    }
}

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


extension UIImage {

    func blurImage() -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let originalOrientation = imageOrientation
        let originalScale = scale

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(2, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage

        var cgImage:CGImage?

        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }

        if let cgImageA = cgImage
        {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }

        return nil
    }
}

public class ContainerCollectionCell<Child: UIView>: UICollectionViewCell {
    var child: Child? {
        didSet { updateChild() }
    }

    func updateChild(
        excluding excludedEdge: LayoutEdge = .none,
        insets: TinyEdgeInsets = .zero,
        relation: ConstraintRelation = .equal,
        priority: LayoutPriority = .required,
        isActive: Bool = true,
        usingSafeArea: Bool = false
    ) {
        guard let child = child else { return }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(child)

        child.edgesToSuperview(
            excluding: excludedEdge,
            insets: insets,
            relation: relation,
            priority: priority,
            isActive: isActive,
            usingSafeArea: usingSafeArea
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        child = Child()
        updateChild()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BlurredCardView: UIView {

    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    public init() {
        super.init(frame: CGRect.zero)

        addSubview(effectView)

        effectView.edgesToSuperview()

        layer.masksToBounds = true
        layer.cornerRadius = 20
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

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    class CurrentLocationProvider: LocationProvider {
        var location: Location

        internal init(location: Location) {
            self.location = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            suggestionService = Suggestions.createService(of: .dailySuggestionServiceType(
                storage: Storage.createService(of: .userDefaults),
                dateProvider: CurrentDateProvider(),
                locationProvider: CurrentLocationProvider(location: .init(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )),
                api: API.createService(of: .kiwi),
                maxNumberOfSuggestions: 5
            ))
        } else {
            suggestionService = Suggestions.createService(of: .dailySuggestionServiceType(
                storage: Storage.createService(of: .userDefaults),
                dateProvider: CurrentDateProvider(),
                locationProvider: CurrentLocationProvider(location: .init(latitude: 51.5, longitude: 0.12)),
                api: API.createService(of: .kiwi),
                maxNumberOfSuggestions: 5
            ))
        }

        kek()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        suggestionService = Suggestions.createService(of: .dailySuggestionServiceType(
            storage: Storage.createService(of: .userDefaults),
            dateProvider: CurrentDateProvider(),
            locationProvider: CurrentLocationProvider(location: .init(latitude: 51.5, longitude: 0.12)),
            api: API.createService(of: .kiwi),
            maxNumberOfSuggestions: 5
        ))

        kek()
    }

    let manager = CLLocationManager()

    var collectionDataSource: [Flight] = []

    let imageView = UIImageView()

    var images: [String: UIImage] = [:]

    struct CurrentDateProvider: DateProvider {
        var date: Date = Date()
    }

    var suggestionService: SuggestionsService?

    var selectedIndexPath: IndexPath?

    typealias FlightCardCollectionView = ContainerCollectionCell<FlightBlurredCardView>

    lazy var propertyAnimator = UIViewPropertyAnimator(duration: 3.0, curve: .linear)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Zoomed & snapped cells"

        guard let collectionView = collectionView else { fatalError() }
        //collectionView.decelerationRate = .fast // uncomment if necessary
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(FlightCardCollectionView.self, forCellWithReuseIdentifier: "Cell")

        view.addSubview(imageView)
        view.bringSubviewToFront(collectionView)
        imageView.contentMode = .scaleAspectFill

        collectionView.backgroundColor = .clear

        imageView.edgesToSuperview()

        manager.delegate = self
        if #available(iOS 14.0, *) {
            manager.desiredAccuracy = kCLLocationAccuracyReduced
        } else {
        }

        manager.requestWhenInUseAuthorization()
    }

    func kek() {
        suggestionService?.getFlightSuggestions { [weak self] in
            switch $0 {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.collectionDataSource = success.suggestedFlights
                    self?.images = success.destinationImages.compactMapValues { UIImage(data: $0)?.blurImage() }
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataSource.count
    }

    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! FlightCardCollectionView

        cell.child?.flightCardView.configure(with: collectionDataSource[indexPath.item])

        return cell
    }

    let transition = CardTransitionDelegate()

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath

        let vc = FlightFullDetailsViewController(viewModel: (), routes: ())
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width * 0.75, height: 400)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        view.frame.width / 13
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard collectionDataSource.count > 0 else {
            return
        }
//        let x = collectionView.contentOffset.x + (collectionView.frame.width / 2)
//        let y = collectionView.frame.height - 400/2
//
//        guard let indexPath = collectionView.indexPathForItem(at: .init(x: x, y: y)) else {
//            print("Nothing")
//            return
//        }

        let maximum = (view.frame.width * 0.75) * CGFloat(collectionDataSource.count)
            + (view.frame.width / 13 * CGFloat(collectionDataSource.count - 1))

        let percentage = (collectionView.contentOffset.x + view.frame.width * 0.75 / 2) / maximum

        let pure = min(max(percentage, 0), 1)

        propertyAnimator.fractionComplete = pure

//        print((pure * CGFloat(images.count)).rounded(.down))

        let image = images[collectionDataSource[Int((pure * CGFloat(images.count)).rounded(.down))].mapIdto!]

        if imageView.image != image {
            UIView.transition(
                with: imageView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { self.imageView.image = image }
            )
        }
    }

}

class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {

    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.1

    override init() {
        super.init()

        scrollDirection = .horizontal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        let itemSize = CGSize(width: collectionView.frame.width * 0.75, height: 400)
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height - 20)
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: 20, right: horizontalInsets)

        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        // Make the cells be zoomed when they reach the center of the screen
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.transform3D = CATransform3DTranslate(
                    attributes.transform3D, 0, -(attributes.bounds.height * zoom - attributes.bounds.height) / 2, 0
                )
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return rectAttributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}

extension Date {
    public func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    public func asTimeString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        return dateFormatter.string(from: self)
    }

    public func asDateTimeString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        return dateFormatter.string(from: self)
    }

    public func asString(withFormat format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
