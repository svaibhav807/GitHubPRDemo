//
//  NetworkClient.swift
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

enum APIRequestBody {
    case none
    case jsonArray([Any])
    case jsonDictionary([String: Any])
    case data(Data)
}

class GitPRAPIClient {
    func fetchPRs(completion: @escaping (Result<[GitPRModel],APIError>) -> Void) {

        let completeURL = Constants.APIBaseURL + Constants.Paths.pullRequestPath
        var parameters: [String: String] = [:]
        parameters["state"] = "open"
        let request = AF.request("https://api.github.com/repos/johnsundell/ShellOut/pulls?state=closed", parameters: parameters, encoder: URLEncodedFormParameterEncoder.default) { request in

        }
        request.responseDecodable(of: [GitPRModel].self) { [weak self] (response) in
           
            if let error = response.error {
                self?.delegate?.showErrorView(with: .requestFailed)
                self?.delegate?.reloadCollectionView()

                return
            }

            guard let items = response.value else { return }
            self?.prDetailModel.append(contentsOf: items)
            self?.cellViewModels = []
            //            for _ in 0...5 {
            for item in items {
                let cvm = GitPRCellViewModel(item: item)
                print(item.closedDate,"10101")
                self?.cellViewModels.append(cvm)
            }
            //            }
            self?.delegate?.reloadCollectionView()
            self?.collectionView?.reloadData()
        }
    }

    func fetchUser() {
        let completeURL = Constants.APIBaseURL + Constants.Paths.userProfilePath
        let request = AF.request(completeURL)

        request.responseDecodable(of: GitUserModel.self) { [weak self] (response) in
            guard let item = response.value else { return }
            self?.gitUserModel = item
            print(item)
            self?.delegate?.loadUserData()
        }
    }


}
