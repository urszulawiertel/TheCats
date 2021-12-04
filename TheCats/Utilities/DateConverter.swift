//
//  DateConverter.swift
//  TheCats
//
//  Created by Ula on 04/12/2021.
//

import Foundation

protocol DateConverting {
    func formatDate(_ string: String) -> String?
}

struct DateConverter: DateConverting {
    private let inputDateFormatter: DateFormatter
    private let outputDateFormatter: DateFormatter

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

    init(inputDateFormatter: DateFormatter, outputDateFormatter: DateFormatter) {
        self.inputDateFormatter = inputDateFormatter
        self.outputDateFormatter = outputDateFormatter
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
