//
//  ZoomFlowLayout.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 01.06.2021.
//

import UIKit

class ZoomFlowLayout: UICollectionViewFlowLayout {

    let activeDistance: CGFloat = 200
    let zoomMultiplier: CGFloat = 0.1
    let bottomInset: CGFloat = 20
    let itemHeight: CGFloat
    let itemWidthMultiplier: CGFloat


    public init(itemHeight: CGFloat, itemWidthMultiplier: CGFloat) {
        self.itemHeight = itemHeight
        self.itemWidthMultiplier = itemWidthMultiplier
        super.init()

        scrollDirection = .horizontal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }

        let itemSize = CGSize(width: collectionView.frame.width * 0.75, height: 450)

        let verticalInsets = collectionView.frame.height
            - collectionView.adjustedContentInset.top
            - collectionView.adjustedContentInset.bottom
            - itemSize.height - bottomInset

        let horizontalInsets = (collectionView.frame.width
            - collectionView.adjustedContentInset.right
            - collectionView.adjustedContentInset.left
            - itemSize.width) / 2
        sectionInset = .init(top: verticalInsets, left: horizontalInsets, bottom: bottomInset, right: horizontalInsets)

        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = (super.layoutAttributesForElements(in: rect) ?? [])
            .map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomMultiplier * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.transform3D = CATransform3DTranslate(
                    attributes.transform3D, 0, -(attributes.bounds.height * zoom - attributes.bounds.height) / 2, 0
                )
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return rectAttributes
    }

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        let targetRect = CGRect(
            x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height
        )
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
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
            as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
