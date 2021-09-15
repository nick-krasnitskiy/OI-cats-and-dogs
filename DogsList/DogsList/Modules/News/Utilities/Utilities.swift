//
//  Utilities.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 27.08.2021.
//

import UIKit

class DateConvert: NSObject {
    static let shared = DateConvert()

    func getDate(date: String) -> String {
        let dateFormatter = DateFormatter.serverDateFormatter()
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date)
    }

}

extension DateFormatter {
    static func serverDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter
    }
}
