//
//  Transformable.swift
//  CommonModels
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

public protocol Transformable {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
