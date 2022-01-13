//
//  AuthenticationPresenter.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import CommonModels
import Combine

public class AuthenticationPresenter<ViewModel: Transformable, Routes: AuthenticationRoutes>
where ViewModel.Input == AuthenticationViewModelInput, ViewModel.Output == AuthenticationViewModelOutput {
    let viewModel: ViewModel
    let routes: Routes
    
    let phoneNumber: PassthroughSubject<String, Never> = .init()
    let password: PassthroughSubject<String, Never> = .init()
    let error: PassthroughSubject<AuthenticationError, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(viewModel: ViewModel, routes: Routes) {
        self.viewModel = viewModel
        self.routes = routes
        
        let output = viewModel.transform(input: .init(
            start: Just(()).eraseToAnyPublisher(),
            phoneNumber: phoneNumber.eraseToAnyPublisher(),
            password: password.eraseToAnyPublisher()
        ))
        
        output.complete.sink { [weak self] in self?.routes.completeAuthentication() }.store(in: &cancellables)
        output.error.sink { [weak self] in self?.error.send($0) }.store(in: &cancellables)
        output.nextStep.sink { [weak self] in self?.onNextStep($0) }.store(in: &cancellables)
    }
    
    func onNextStep(_ step: AuthenticationStep) {
        switch step {
        case .phoneNumber:
            routes.openPhoneNumberStep(phoneNumberSubscriper: phoneNumber.toAnySubscriber)
        case .password:
            routes.openPasswordStep(
                passwordSubscriper: password.toAnySubscriber, error: error.map(\.description).eraseToAnyPublisher()
            )
        }
    }
    
    deinit {
        print("deinit")
    }
}

extension Subject {
    public var toAnySubscriber: AnySubscriber<Output, Failure> {
        var cancellable: Cancellable?
        return .init(
            receiveSubscription: {
                cancellable = $0
            },
            receiveValue: {
                self.send($0)

                return Subscribers.Demand.unlimited
            },
            receiveCompletion: {
                self.send(completion: $0)
                cancellable = nil
            }
        )
    }
}
