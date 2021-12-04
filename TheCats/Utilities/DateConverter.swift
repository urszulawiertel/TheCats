//
//  DateConverter.swift
//  TheCats
//
//  Created by Ula on 04/12/2021.
//

import Foundation

protocol DateConverting {
    func formatDate(_ string: String) -> String?
    func getDate(_ string: String) -> Date?
}

struct DateConverter: DateConverting {

    let inputDateFormatter: DateFormatter
    let outputDateFormatter: DateFormatter

    init(inputDateFormatter: DateFormatter, outputDateFormatter: DateFormatter) {
        self.inputDateFormatter = inputDateFormatter
        self.outputDateFormatter = outputDateFormatter
    }

    /// Converts a date from the API using DateFormatter().
    /// - Parameter string: Date to format
    /// - Returns: Returns a string converted to a given date format.
    func formatDate(_ string: String) -> String? {
        if let date = inputDateFormatter.date(from: string) {
            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }

    /// Converts a string to a Date object
    func getDate(_ string: String) -> Date? {
        return inputDateFormatter.date(from: string)
    }
}

extension DateFormatter {
    /// Returns the date in the format received from the API request.
    static var defaultDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }

    /// Returns a date in the following format: numeric day of the month, numeric month and the 4-digit year.
    /// Example: 30/12/2021.
    static var dayMonthYearDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
}
