//
//  MockReposListPresenter.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
@testable import GitRepos

class MockReposListPresenter: ViewToPresenterReposListProtocol {
    
    var fetchReposSuccessCalled = false
    var fetchReposFailureCalled = false
    
    var view: PresenterToViewReposListProtocol?
    var interactor: PresenterToInteractorReposListProtocol?
    var router: PresenterToRouterReposListProtocol?
    var repos: [Repo]?
    var searchBarQuery: String = ""
    var queryForDisplayedRepos: String = ""
    var page: Int = 1
    var totalRepos: Int = 0
    var shouldScrollToTop: Bool = false
    var searchTask: DispatchWorkItem?
    
    var viewDidLoadCalled = false
    var isNoResultsFoundLabelHiddenCalled = false
    var numberOfRowsInSectionCalled = false
    var repoForRowAtCalled = false
    var updateSearchResultsCalled = false
    
    var valueToReturnForIsNoResultsFoundLabelHidden = true
    var valueToReturnForNumberOfRowsInSection: Int = 0
    var valueToReturnForRepoForRowAt: Repo?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func isNoResultsFoundLabelHidden() -> Bool {
        isNoResultsFoundLabelHiddenCalled = true
        return valueToReturnForIsNoResultsFoundLabelHidden
    }
    
    func numberOfRowsInSection() -> Int {
        numberOfRowsInSectionCalled = true
        return valueToReturnForNumberOfRowsInSection
    }
    
    func repoForRowAt(indexPath: IndexPath) -> Repo? {
        repoForRowAtCalled = true
        return valueToReturnForRepoForRowAt
    }
    
    func updateSearchResults(withQuery query: String) {
        updateSearchResultsCalled = true
    }
}

extension MockReposListPresenter: InteractorToPresenterReposListProtocol {
    
    func fetchReposSuccess(repos: [Repo], forQuery: String, total: Int) {
        fetchReposSuccessCalled = true
    }
    
    func fetchReposFailure(errorCode: Int) {
        fetchReposFailureCalled = true
    }
}
