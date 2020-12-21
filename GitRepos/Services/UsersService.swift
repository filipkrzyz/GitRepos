//
//  UsersService.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

protocol UsersServiceProtocol {
    func fetchFollowersForUser(withUserUrl stringUrl: String, completion: @escaping(Int?) -> Void)
}

class UsersService: UsersServiceProtocol {
    
    static let shared = UsersService()
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchFollowersForUser(withUserUrl stringUrl: String, completion: @escaping(Int?) -> Void) {
        guard let url = URL(string: stringUrl) else {
            completion(nil)
            return
        }
        
        urlSession.dataTask(with: url) { (data, _, error) in
            guard let jsonData = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let gitUser = try JSONDecoder().decode(GitUser.self, from: jsonData)
                completion(gitUser.followersCount)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
