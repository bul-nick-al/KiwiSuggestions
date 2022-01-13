//
//  PasswordStepPresenter.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import UIKit
import Combine
import CommonModels

public class PasswordStepPresenter: PasswordStepConfiguration {
    @Published public var password: String = ""
    @Published public var onNext: Void = ()
    @Published public var error: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    public init(password: AnySubscriber<String, Never>, error: AnyPublisher<String, Never>) {
        $onNext
            .compactMap { [weak self] in self?.password }
            .dropFirst()
            .sink(receiveValue: { _ = password.receive($0) })
            .store(in: &cancellables)
        
        error.sink { [weak self] in self?.error = $0 }.store(in: &cancellables)
    }
}
