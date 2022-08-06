//
//  GitFormatters.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
class GitFormatters {
    class Dates {
        private lazy var formatter: DateFormatter = {
            let f = DateFormatter()
            // Format - 10 January 2019
            f.dateFormat = "dd MMMM yyyy"
            f.locale = Locale(identifier: "en_US_POSIX")
            return f
        }()

        func string(from date: Date) -> String? {
            return formatter.string(from: date)
        }

        func string(from isoString: String) -> String? {
            let dateFormatter = ISO8601DateFormatter()
            guard let date = dateFormatter.date(from:isoString) else { return nil }
            return string(from: date)
        }
    }
}
