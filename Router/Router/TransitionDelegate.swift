//
//  TransitionDelegate.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 30.05.2021.
//

import UIKit
import SuggestionsScreen

class CardTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var interactionController: VerticalSwipeInteractionController?

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        ExpandPresentAnimator { [weak self] in
            self?.interactionController = .init(
                viewController: $0.viewController(forKey: .to)!, view: $0.view(forKey: .to)!
            )
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CollapseDismissAnimator()
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        guard let interactionController = interactionController, interactionController.interactionInProgress
        else { return nil }

        return interactionController
    }
}

class ExpandPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties
    var transitionDriver: FlipTransitionDriver?

    var onAnimate: ((UIViewControllerContextTransitioning) -> Void)?

    init(onAnimate: ((UIViewControllerContextTransitioning) -> Void)?) {
        self.onAnimate = onAnimate
    }

    // MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
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

    private func createAnimator() {
        container.addSubview(toView)
        toView.frame = self.container.frame

        guard
            let fromViewController = fromViewController as? FlightSuggestionsViewController,
            let selectedIndexPath = fromViewController.selectedIndexPath,
            let cardView = fromViewController.collectionView.cellForItem(at: selectedIndexPath)
                                as? FlightSuggestionsViewController.FlightCardCollectionView,
            let fromSnapshot = cardView.snapshotView(afterScreenUpdates: false),
            let toSnapshot = toView.snapshotView(afterScreenUpdates: true)
        else {
            completeAnimation()
            return
        }

        container.addSubview(fromSnapshot)
        container.addSubview(toSnapshot)

        fromSnapshot.frame = cardView.frameInParentCoordinates
        let ratio = cardView.bounds.height / cardView.bounds.width


        container.layoutIfNeeded()

        toSnapshot.frame = cardView.frameInParentCoordinates
        toSnapshot.alpha = 0

        toView.alpha = 0
        cardView.alpha = 0

        UIView.animate(withDuration: 0.1, animations: {
            fromSnapshot.frame = .init(
                origin: self.container.frame.origin,
                size: .init(width: self.container.frame.width, height: self.container.frame.width * ratio)
            )
            toSnapshot.frame = self.container.frame

            fromSnapshot.alpha = 0.0
            toSnapshot.alpha = 1.0
        }, completion: { _ in
            toSnapshot.removeFromSuperview()
            fromSnapshot.removeFromSuperview()
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

class CollapseDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties
    var transitionDriver: VerticalDragTransitionDriver?

    // MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = VerticalDragTransitionDriver(transitionContext: transitionContext)
    }

    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }
}
