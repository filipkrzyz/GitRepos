//
//  MockUsersService.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
@testable import GitRepos

class MockUsersService: UsersServiceProtocol {
    
    var fetchFollowersForUserCalled: Bool = false
    var mockFollowersCount: Int = 0
    
    func fetchFollowersForUser(withUserUrl stringUrl: String, completion: @escaping (Int?) -> Void) {
        fetchFollowersForUserCalled = true
        completion(mockFollowersCount)
    }
    
}
