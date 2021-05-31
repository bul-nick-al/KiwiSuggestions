//
//  TransitionDelegate.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 30.05.2021.
//

import UIKit

class CardTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var interactionController: VerticalSwipeInteractionController?

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        FlipPresentAnimator { [weak self] in
            self?.interactionController = .init(viewController: $0.viewController(forKey: .to)!, view: $0.view(forKey: .to)!)
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipDismissAnimator()
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        guard let interactionController = interactionController, interactionController.interactionInProgress
        else { return nil }

        return interactionController
    }
}

class FlipPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties
    var transitionDriver: FlipTransitionDriver?

    var onAnimate: ((UIViewControllerContextTransitioning) -> Void)?

    init(onAnimate: ((UIViewControllerContextTransitioning) -> Void)?) {
        self.onAnimate = onAnimate
    }

    // MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = FlipTransitionDriver(transitionContext: transitionContext)
        onAnimate?(transitionContext)
    }

    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }
}

class FlipTransitionDriver {

    // MARK: - Properties
    private let context: UIViewControllerContextTransitioning
    private let container: UIView
    private let fromViewController: UIViewController
    private let toViewController: UIViewController
    private let fromView: UIView
    private let toView: UIView

    // MARK: - Lifecycle
    required init(transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        container = transitionContext.containerView
        fromViewController = transitionContext.viewController(forKey: .from)!
        toViewController = transitionContext.viewController(forKey: .to)!
        fromView = fromViewController.view!
        toView = toViewController.view!

        createAnimator()
    }

    // MARK: - Methods

    func frameOfViewInWindowsCoordinateSystem(_ view: UIView) -> CGRect {
        if let superview = view.superview {
            return superview.convert(view.frame, to: nil)
        }
        print("[ANIMATION WARNING] Seems like this view is not in views hierarchy\n\(view)\nOriginal frame returned")
        return view.frame
    }

    private func createAnimator() {
        container.addSubview(toView)

//        toView.horizontalToSuperview()
//        container.layoutIfNeeded()
//
        guard
            let fromViewController = fromViewController as? ViewController,
            let cardView = (fromViewController.collectionView.cellForItem(at: fromViewController.selectedIndexPath!)
                                as? ViewController.FlightCardCollectionView),
            let toViewController = toViewController as? FlightFullDetailsViewController,
            let snapshot = cardView.snapshotView(afterScreenUpdates: false)
        else { return }
//
//        let toView = self.toView as? FlightCardView


        container.addSubview(snapshot)

        snapshot.frame = frameOfViewInWindowsCoordinateSystem(cardView)
        let ratio = cardView.bounds.height / cardView.bounds.width

        toView.frame = self.container.frame
        container.layoutIfNeeded()

        let snapshot2 = toView.snapshotView(afterScreenUpdates: true)!
        container.addSubview(snapshot2)
        snapshot2.frame = frameOfViewInWindowsCoordinateSystem(cardView)
        snapshot2.alpha = 0

        toView.alpha = 0
        cardView.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            snapshot.frame = .init(origin: self.container.frame.origin, size: .init(width: self.container.frame.width, height: self.container.frame.width * ratio))
            snapshot2.frame = self.container.frame

            snapshot.alpha = 0.0
            snapshot2.alpha = 1.0
        }, completion: { _ in
            snapshot2.removeFromSuperview()
            snapshot.removeFromSuperview()
            self.toView.alpha = 1.0
            self.completeAnimation()
        })
    }

    private func completeAnimation() {
        let success = !context.transitionWasCancelled
        context.completeTransition(success)
    }
}

class VerticalSwipeInteractionController: UIPercentDrivenInteractiveTransition {

    // MARK: - Constants

    private let progressThreshold: CGFloat = 0.5

    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    private weak var view: UIView!

    private var previousProgress: CGFloat = 0

    var interactionInProgress = false

    init(viewController: UIViewController, view: UIView) {
        super.init()
        self.viewController = viewController
        self.view = view
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:))))
    }

    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        // 1
        let translation = gestureRecognizer.translation(in: view)
        var progress = (abs(translation.y) / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            if
                previousProgress > progressThreshold && progress <= progressThreshold
                ||
                previousProgress < progressThreshold && progress >= progressThreshold
            {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            shouldCompleteTransition = progress > progressThreshold
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition { finish() } else { cancel() }
        default:
            break
        }

        previousProgress = progress
    }
}

class FlipDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties
    var transitionDriver: FlipBackTransitionDriver?

    // MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = FlipBackTransitionDriver(transitionContext: transitionContext)
    }

    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }
}

class FlipBackTransitionDriver {

    // MARK: - Properties
    private let context: UIViewControllerContextTransitioning
    private let container: UIView
    private let fromViewController: UIViewController
    private let toViewController: UIViewController
    private let fromView: UIView
    private let toView: UIView

    // MARK: - Lifecycle
    required init(
        transitionContext: UIViewControllerContextTransitioning
    ) {
        context = transitionContext
        container = transitionContext.containerView
        fromViewController = transitionContext.viewController(forKey: .from)!
        toViewController = transitionContext.viewController(forKey: .to)!
        fromView = fromViewController.view!
        toView = toViewController.view!
        createAnimator()
    }

    // MARK: - Methods

    func frameOfViewInWindowsCoordinateSystem(_ view: UIView) -> CGRect {
        if let superview = view.superview {
            return superview.convert(view.frame, to: nil)
        }
        print("[ANIMATION WARNING] Seems like this view is not in views hierarchy\n\(view)\nOriginal frame returned")
        return view.frame
    }

    private func createAnimator() {
//        toView.horizontalToSuperview()
//        container.layoutIfNeeded()
//
        guard
            let fromViewController = fromViewController as? FlightFullDetailsViewController,
            let toViewController = toViewController as? ViewController,
            let cardView = (toViewController.collectionView.cellForItem(at: toViewController.selectedIndexPath!)
                                as? ViewController.FlightCardCollectionView)
        else { return }

        cardView.alpha = 1
        let snapshot = cardView.snapshotView(afterScreenUpdates: true)!
        cardView.alpha = 0

        container.addSubview(snapshot)

        let ratio = cardView.bounds.height / cardView.bounds.width
        snapshot.frame = .init(origin: self.container.frame.origin, size: .init(width: self.container.frame.width, height: self.container.frame.width * ratio))

        container.layoutIfNeeded()
        snapshot.alpha = 0

        let snapshot2 = fromView.snapshotView(afterScreenUpdates: false)!
        container.addSubview(snapshot2)
        snapshot2.frame = container.frame
        snapshot2.alpha = 1

        toView.alpha = 1
        fromView.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            snapshot.frame = self.frameOfViewInWindowsCoordinateSystem(cardView)
            snapshot2.frame = self.frameOfViewInWindowsCoordinateSystem(cardView)

            snapshot.alpha = 1
            snapshot2.alpha = 0
        }, completion: { _ in
            snapshot2.removeFromSuperview()
            snapshot.removeFromSuperview()
            cardView.alpha = 1
            self.fromView.alpha = 1
            self.completeAnimation()
        })
    }

    private func completeAnimation() {
        let success = !context.transitionWasCancelled
        context.completeTransition(success)
    }
}
