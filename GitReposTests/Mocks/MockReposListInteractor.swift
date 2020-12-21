//
//  MockReposListInteractor.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 20/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
@testable import GitRepos

class MockReposListInteractor: PresenterToInteractorReposListProtocol {
    var presenter: InteractorToPresenterReposListProtocol?
    var reposService: ReposServiceProtocol?
    
    var loadReposCalled = false
    var passedQuery = ""
    var passedPage = 0
    
    func loadRepos(withQuery query: String, page: Int) {
        loadReposCalled = true
        passedQuery = query
        passedPage = page
    }
}
