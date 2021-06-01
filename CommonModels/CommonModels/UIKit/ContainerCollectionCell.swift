//
//  ContainerCollectionCell.swift
//  CommonModels
//
//  Created by Николай Булдаков on 31.05.2021.
//

import UIKit
import TinyConstraints

public class ContainerCollectionCell<Child: UIView>: UICollectionViewCell {
    public var child: Child? {
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
