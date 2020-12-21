//
//  Repository.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct ReposResponse: Decodable {
    let totalCount: Int
    var repos: [Repo]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case repos = "items"
    }
}

struct Repo: Decodable {
    let repoId: Int
    let fullName: String
    var gitUser: GitUser
    let description: String?
    let watchersCount: Int
    let forksCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case repoId = "id"
        case fullName = "full_name"
        case gitUser = "owner"
        case description
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
    }
}

struct GitUser: Decodable {
    let avatarUrl: String?
    let profileUrl: String
    var followersCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case profileUrl = "url"
        case followersCount = "followers"
    }
}
