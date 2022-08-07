//
//  GitUserModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation

struct GitUserModel: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let company: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "avatar_url"
        case name
        case location
        case company
    }
}
