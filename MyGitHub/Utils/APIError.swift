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
    case noData
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .requestFailed:
            return "Something went wrong, Please try again"
        case .invalidData:
            return "Something went wrong, Please try again"
        case .noData:
            return "You dont have any pull requests."
        }
    }
}
