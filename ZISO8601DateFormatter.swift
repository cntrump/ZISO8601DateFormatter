//
//  ZISO8601DateFormatter.swift
//  ZISO8601DateFormatter
//
//  Created by v on 2020/10/26.
//

import Foundation

public class ZISO8601DateFormatter: DateFormatter {
    
    private var _dateOptionsFormat: String = ""
    
    public var formatOptions: ZISO8601DateFormatter.Options = .withInternetDateTime {
        didSet {
            _dateOptionsFormat = dateFormat(from: formatOptions)
        }
    }
    
    private func dateFormat(from options: ZISO8601DateFormatter.Options) -> String {
        var year = "", month = "", weakOfYear = "",
            day = "", hour = "", minute = "", second = "",
            fractionalSeconds = "", timeZone = "",
            dateAndTime = "", inDate = "", inTime = ""
        
        if formatOptions.contains(.withWeekOfYear) {
            year = "YYYY"
            day = "ee"
            weakOfYear = "'W'ww"
        }

        if formatOptions.contains(.withYear) {
            if year.isEmpty {
                year = "yyyy"
            }
        }

        if formatOptions.contains(.withMonth) {
            month = "MM"
            if day.isEmpty {
                day = "dd"
            }
        }

        if formatOptions.contains(.withDay) {
            if day.isEmpty {
                day = "DDD"
            }
        }

        if formatOptions.contains(.withTime) {
            hour = "HH"
            minute = "mm"
            second = "ss"
            dateAndTime = "'T'"

            if formatOptions.contains(.withFractionalSeconds) {
                fractionalSeconds = ".SSS"
            }

            if formatOptions.contains(.withColonSeparatorInTime) {
                inTime = ":"
            }

            if formatOptions.contains(.withSpaceBetweenDateAndTime) {
                dateAndTime = " "
            }
        }
            
        if formatOptions.contains(.withTimeZone) {
            if formatOptions.contains(.withColonSeparatorInTimeZone) {
                    timeZone = "ZZZZZ"
            } else {
                if self.timeZone.secondsFromGMT() != 0 {
                    timeZone = "ZZZ"
                } else {
                    timeZone = "ZZZZZ"
                }
            }
        }

        if formatOptions.contains(.withDashSeparatorInDate) {
            inDate = "-"

            if (weakOfYear.count > 0) {
                weakOfYear = "-\(weakOfYear)-"
            } else {
                weakOfYear = inDate
            }
        }
        
        let dateFormat = year + inDate + month + weakOfYear + day + dateAndTime +
                         hour + inTime + minute + inTime + second + fractionalSeconds + timeZone

        return dateFormat
    }
    
    public override func string(from date: Date) -> String {
        dateFormat = _dateOptionsFormat
        
        return super.string(from: date)
    }
    
    public override func date(from string: String) -> Date? {
        dateFormat = _dateOptionsFormat
        
        return super.date(from: string)
    }
}

extension ZISO8601DateFormatter {
    
    public struct Options: OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        /* The format for year is inferred based on whether or not the week of year option is specified.
         - if week of year is present, "YYYY" is used to display week dates.
         - if week of year is not present, "yyyy" is used by default.
        */
        public static let withYear = ZISO8601DateFormatter.Options(rawValue: 1 << 0)
        public static var withMonth = ZISO8601DateFormatter.Options(rawValue: 1 << 1)

        public static var withWeekOfYear = ZISO8601DateFormatter.Options(rawValue: 1 << 2) // This includes the "W" prefix (e.g. "W49")

        /* The format for day is inferred based on provided options.
         - if month is not present, day of year ("DDD") is used.
         - if month is present, day of month ("dd") is used.
         - if either weekOfMonth or weekOfYear is present, local day of week ("ee") is used.
        */
        public static var withDay = ZISO8601DateFormatter.Options(rawValue: 1 << 4)

        public static var withTime = ZISO8601DateFormatter.Options(rawValue: 1 << 5) // This uses the format "HHmmss"
        public static var withTimeZone = ZISO8601DateFormatter.Options(rawValue: 1 << 6)

        public static var withSpaceBetweenDateAndTime = ZISO8601DateFormatter.Options(rawValue: 1 << 7) // Use space instead of "T"
        public static var withDashSeparatorInDate = ZISO8601DateFormatter.Options(rawValue: 1 << 8) // Add separator for date ("-")
        public static var withColonSeparatorInTime = ZISO8601DateFormatter.Options(rawValue: 1 << 9) // Add separator for time (":")
        public static var withColonSeparatorInTimeZone = ZISO8601DateFormatter.Options(rawValue: 1 << 10) // Add ":" separator in timezone (e.g. +08:00)
        public static var withFractionalSeconds = ZISO8601DateFormatter.Options(rawValue: 1 << 11) // Add 3 significant digits of fractional seconds (".SSS")

        public static var withFullDate: ZISO8601DateFormatter.Options = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        public static var withFullTime: ZISO8601DateFormatter.Options = [.withTime, .withColonSeparatorInTime, .withTimeZone, .withColonSeparatorInTimeZone]

        public static var withInternetDateTime: ZISO8601DateFormatter.Options = [.withFullDate, .withFullTime] // RFC 3339
    }
}
