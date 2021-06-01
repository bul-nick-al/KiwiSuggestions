//
//  Date.swift
//  CommonModels
//
//  Created by Николай Булдаков on 31.05.2021.
//

import Foundation

extension Date {
    public func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    public func asTimeString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        return dateFormatter.string(from: self)
    }

    public func asDateTimeString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        return dateFormatter.string(from: self)
    }

    public func asString(withFormat format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
