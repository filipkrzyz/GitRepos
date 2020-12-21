//
//  MockReposService.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
@testable import GitRepos

class MockReposService: ReposServiceProtocol {
    
    var fetchReposCalled: Bool = false
    var mockReposResult: ([Repo], Int) = ([], 0)
    var mockFetchingError: FetchingError?
    
    func fetchRepos(withQuery query: String, page: Int,
                    completion: @escaping (Result<([Repo], Int), FetchingError>) -> Void) {
        fetchReposCalled = true
        if mockFetchingError != nil {
            completion(.failure(mockFetchingError!))
        } else {
            completion(.success(mockReposResult))
        }
    }
}
