//
//  PasswordStepView.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import SwiftUI
import Orbit

public protocol PasswordStepConfiguration: ObservableObject {
    var password: String { get set }
    var onNext: Void { get set }
    var error: String { get }
}

public struct PasswordStepView<Configuration: PasswordStepConfiguration>: View {
    @ObservedObject private var configuration: Configuration
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Orbit.Heading("Enter your password", style: .title3)
            Orbit.InputField(
                value: $configuration.password,
                textContent: .password
            )
            if configuration.error != "" {
                Orbit.Text("Wrong credentials", color: .custom(.red))
            }
            Orbit.Button(
                "Next",
                style: configuration.password.count > 6 ? .primary : .secondary,
                action: { configuration.onNext = () }
            )
        }.padding()
    }
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

struct PasswordStepView_Previews: PreviewProvider {
    @ObservedObject static var kek = Kek()

    static var previews: some View {
        PasswordStepView(configuration: kek)
    }
    
    class Kek: PasswordStepConfiguration {
        @Published var onNext: Void = ()
        
        @Published var password = ""
        @Published var error = ""
    }
}
