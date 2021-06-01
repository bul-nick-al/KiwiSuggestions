//
//  WithBoundView.swift
//  CommonModels
//
//  Created by Николай Булдаков on 01.06.2021.
//

import UIKit

public protocol WithBoundView {
    associatedtype BoundView: UIView
}

extension WithBoundView where Self: UIViewController {
    public var boundView: BoundView {
        self.view as! BoundView
    }
}

extension BaseBoundViewController: WithBoundView {
    public typealias BoundView = BoundView
}


open class BaseBoundViewController<BoundView: UIView>: NiblessViewController {
    open override func loadView() { view = BoundView() }
}
