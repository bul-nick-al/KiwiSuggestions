//
//  VerticalDragTransitionDriver.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 01.06.2021.
//

import UIKit
import SuggestionsScreen

class VerticalDragTransitionDriver {

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

    private func createAnimator() {
        guard
            let toViewController = toViewController as? FlightSuggestionsViewController,
            let cardView = (toViewController.collectionView.cellForItem(at: toViewController.selectedIndexPath!)
                                as? FlightSuggestionsViewController.FlightCardCollectionView)
        else {
            completeAnimation()

            return
        }

        cardView.alpha = 1

        guard
            let snapshot = cardView.snapshotView(afterScreenUpdates: true),
            let snapshot2 = fromView.snapshotView(afterScreenUpdates: false)
        else {
            completeAnimation()

            return
        }

        cardView.alpha = 0

        container.addSubview(snapshot)
        container.addSubview(snapshot2)

        let ratio = cardView.bounds.height / cardView.bounds.width
        snapshot.frame = .init(
            origin: self.container.frame.origin,
            size: .init(width: self.container.frame.width, height: self.container.frame.width * ratio)
        )

        container.layoutIfNeeded()
        snapshot.alpha = 0
        snapshot2.frame = container.frame
        snapshot2.alpha = 1

        toView.alpha = 1
        fromView.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            snapshot.frame = cardView.frameInParentCoordinates
            snapshot2.frame = cardView.frameInParentCoordinates

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
