//
//  PhoneNumberStepPresenter.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import UIKit
import Combine
import CommonModels

public class PhoneNumberStepPresenter: PhoneNumberStepConfiguration {

    @Published public var phoneNumber: String = ""
    public var onNext: PassthroughSubject<Void, Never> = .init()

    private var cancellables = Set<AnyCancellable>()
    
    public init(phoneNumber: AnySubscriber<String, Never>) {
        onNext
            .compactMap { [weak self] in self?.phoneNumber }
            .sink(receiveValue: { _ = phoneNumber.receive($0) })
            .store(in: &cancellables)
    }
}
