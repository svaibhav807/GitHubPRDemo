//
//  NetworkClient.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

enum APIRequestBody {
    case none
    case jsonArray([Any])
    case jsonDictionary([String: Any])
    case data(Data)
}
