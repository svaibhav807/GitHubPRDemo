//
//  APIError.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case invalidData
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .requestFailed:
            return "Network Error, Please try again"
        case .invalidData:
            return "Something went wrong, Please try again"
        }
    }
}
