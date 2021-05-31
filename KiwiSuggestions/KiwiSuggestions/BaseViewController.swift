//
//  BaseViewController.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 30.05.2021.
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


open class BaseBoundViewController<ViewModel, Routes, BoundView: UIView>: BaseViewController<ViewModel, Routes> {
    open override func loadView() { view = BoundView() }
}

open class BaseViewController<ViewModel, Routes>: NiblessViewController {

    public let viewModel: ViewModel

    public let routes: Routes

    public required init(viewModel: ViewModel, routes: Routes) {
        self.viewModel = viewModel
        self.routes = routes
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupView()
    }

    open func setupView() {
        fatalError("Override this method!")
    }

    open func bindViewModel() {
        fatalError("Override this method!")
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

open class NiblessViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(
        *,
        unavailable,
        message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(
        *,
        unavailable,
        message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError(
            "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
        )
    }
}
