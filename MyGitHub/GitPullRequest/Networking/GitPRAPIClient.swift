//
//  GitPRAPIClient.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

class GitPRAPIClient {
    var pageToFetch = 1
    var hasNextPage = true

    func fetchPRs(state: PRState,completion: @escaping (Result<[GitPRModel], APIError>) -> Void) {
        let completeURL = Constants.APIBaseURL + Constants.URLPaths.pullRequestPath
        var parameters: [String: String] = [:]
        parameters["state"] = state.rawValue
        parameters["page"] = String(pageToFetch)

        let request = AF.request(completeURL, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)

        request.responseDecodable(of: [GitPRModel].self) { (response) in
            if let error = response.error {
                switch error {
                case .createURLRequestFailed(_), .sessionTaskFailed(_):
                    completion(.failure(.requestFailed))
                case .invalidURL(_), .responseValidationFailed(_):
                    completion(.failure(.invalidData))
                default:
                    completion(.failure(.requestFailed))
                }
                return
            }
            guard let items = response.value else { return }
            completion(.success(items))
        }
    }

    func fetchUser(completion: @escaping (Result<GitUserModel, APIError>) -> Void) {
        let completeURL = Constants.APIBaseURL + Constants.URLPaths.userProfilePath
        let request = AF.request(completeURL)

        request.responseDecodable(of: GitUserModel.self) { (response) in
            if let error = response.error {
                switch error {
                case .createURLRequestFailed(_), .sessionTaskFailed(_):
                    completion(.failure(.requestFailed))
                case .invalidURL(_), .responseValidationFailed(_):
                    completion(.failure(.invalidData))
                default:
                    completion(.failure(.requestFailed))
                }
                return
            }
            guard let item = response.value else { return }
            completion(.success(item))
        }
    }
}
