//
//  GitPRModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation

class GitPRModel: Codable {
    let prURL: String
    let state: PRState
    var title: String
    let createdDate: String
    let closedDate: String?
    let user: User

    init(prURL: String, state: PRState, title: String, createdDate: String, closedDate: String?, user: User) {
        self.prURL = prURL
        self.title = title
        self.user = user
        self.closedDate = closedDate
        self.createdDate = createdDate
        self.state = state
    }

    enum CodingKeys: String, CodingKey {
        case prURL = "url"
        case title
        case user
        case createdDate = "created_at"
        case closedDate = "closed_at"
        case state
    }
}

extension GitPRModel {
    struct User: Codable {
        let id: Int
        let imageURL: String

        enum CodingKeys: String, CodingKey {
            case id
            case imageURL = "avatar_url"
        }
    }
}

enum PRState: String, Codable {
    case open
    case closed
    case any
}
