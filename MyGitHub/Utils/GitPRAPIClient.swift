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
    func fetchPRs(state: PRState,completion: @escaping (Result<[GitPRModel], APIError>) -> Void) {
        let completeURL = Constants.APIBaseURL + Constants.Paths.pullRequestPath
        var parameters: [String: String] = [:]
        parameters["state"] = state.rawValue
        let request = AF.request(completeURL, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)

        request.responseDecodable(of: [GitPRModel].self) { (response) in
            if let _ = response.error {
                completion(.failure(.requestFailed))
                return
            }
            guard let items = response.value else { return }
            completion(.success(items))
        }
    }

    func fetchUser(completion: @escaping (Result<GitUserModel, APIError>) -> Void) {
        let completeURL = Constants.APIBaseURL + Constants.Paths.userProfilePath
        let request = AF.request(completeURL)

        request.responseDecodable(of: GitUserModel.self) { (response) in
            if let _ = response.error { completion(.failure(.requestFailed)) }
            guard let item = response.value else { return }
            completion(.success(item))
        }
    }
}
