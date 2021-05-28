//
//  Create.swift
//  API
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation

public func createService(of type: ApiServiceType) -> ApiService {
    switch type {
    case .kiwi:
        return KiwiApiService()
    case .mock:
        return ApiMock()
    }
}
