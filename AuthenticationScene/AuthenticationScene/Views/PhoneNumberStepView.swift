//
//  PhoneNumberStepView.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Orbit
import SwiftUI
import Combine

public protocol PhoneNumberStepConfiguration: ObservableObject {
    var phoneNumber: String { get set }
    var onNext: PassthroughSubject<Void, Never> { get }
}

public struct PhoneNumberStepView<Configuration: PhoneNumberStepConfiguration>: View {
    
    @ObservedObject private var configuration: Configuration
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Orbit.Heading("Enter your phone number", style: .title3)
            Orbit.InputField(
                value: $configuration.phoneNumber,
                placeholder: "+34....",
                textContent: .telephoneNumber,
                keyboard: .phonePad
            )
            Orbit.Button(
                "Next",
                style: configuration.phoneNumber.count > 10 ? .primary : .secondary,
                action: { configuration.onNext.send(()) }
            )
        }.padding()
    }
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

struct PhoneNumberStepView_Previews: PreviewProvider {
    
    @ObservedObject static var kek = Kek()
    
    static var previews: some View {
        PhoneNumberStepView(configuration: kek)
    }
    
    class Kek: PhoneNumberStepConfiguration {
        
        
        var onNext: PassthroughSubject<Void, Never> = .init()
        
        @Published var phoneNumber = ""
    }
}
