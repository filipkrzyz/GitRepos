//
//  ReposService.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 16/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

enum FetchingError: Error {
    case noDataAvailable
    case canNotProcessData
    case errorFetchingData
    case errorCreatingUrl
}

protocol ReposServiceProtocol {
    func fetchRepos(withQuery query: String, page: Int,
                    completion: @escaping(Result<([Repo], Int), FetchingError>) -> Void)
}

class ReposService: ReposServiceProtocol {
    
    private let urlSession: URLSession
    private let usersService: UsersServiceProtocol
    
    static let shared = ReposService()
    
    private let reposStringUrl = "https://api.github.com/search/repositories"
    
    init(urlSession: URLSession = .shared,
         usersService: UsersServiceProtocol = UsersService.shared) {
        self.urlSession = urlSession
        self.usersService = usersService
    }
    
    func fetchRepos(withQuery query: String, page: Int,
                    completion: @escaping(Result<([Repo], Int), FetchingError>) -> Void) {
        
        let stringUrl = reposStringUrl + "?q=\"\(query)\"&page=\(page)"
        
        guard let encodedStringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.errorCreatingUrl))
            return
        }
        
        guard let url = URL(string: encodedStringUrl) else {
            completion(.failure(.errorCreatingUrl))
            return
        }
        
        urlSession.dataTask(with: url) { [weak self] (data, _, error) in
            
            guard error == nil else {
                completion(.failure(.errorFetchingData))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let reposResponse = try JSONDecoder().decode(ReposResponse.self, from: jsonData)
                
                var repos = reposResponse.repos
                
                guard repos.count != 0 else {
                    completion(.success((repos, reposResponse.totalCount)))
                    return
                }
                
                for (index, repo) in repos.enumerated() {
                    self?.usersService.fetchFollowersForUser(withUserUrl: repo.gitUser.profileUrl) { followersCount in
                        repos[index].gitUser.followersCount = followersCount

                        if index == repos.count - 1 {
                            completion(.success((repos, reposResponse.totalCount)))
                        }
                    }
                }
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }.resume()
    }
}
