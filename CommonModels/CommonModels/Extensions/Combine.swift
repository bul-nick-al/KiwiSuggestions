//
//  Combine.swift
//  CommonModels
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import Combine

extension Future where Failure == Never {
    convenience public init(_ asyncFunction: @escaping () async -> Output) {
        self.init { promise in Task { promise(.success(await asyncFunction())) } }
    }
}

extension Future where Failure == Error {
    convenience public init(_ asyncFunction: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    promise(.success(try await asyncFunction()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
