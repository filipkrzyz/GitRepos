//
//  ReposListPresenterTests.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import XCTest
@testable import GitRepos

class ReposListPresenterTests: XCTestCase {
    
    var sut: ReposListPresenter!
    var repo1, repo2: Repo!
    var mockInteractor: MockReposListInteractor!
    var mockView: MockReposListViewController!
    
    override func setUp() {
        sut = ReposListPresenter()
        
        repo1 = Repo(repoId: 1, fullName: "",
                     gitUser: GitUser(avatarUrl: "",
                                      profileUrl: "",
                                      followersCount: 0),
                     description: "", watchersCount: 0, forksCount: 0)
        repo2 = Repo(repoId: 2, fullName: "",
                     gitUser: GitUser(avatarUrl: "",
                                      profileUrl: "",
                                      followersCount: 0),
                     description: "", watchersCount: 0, forksCount: 0)
        
        mockInteractor = MockReposListInteractor()
        mockView = MockReposListViewController()
        sut.interactor = mockInteractor
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockInteractor = nil
        mockView = nil
    }
    
    // MARK: isNoResultsFoundLabelHidden()
    func testIsNoResultsFoundLabelHidden_whenReposNotEmpty_returnsTrue() {
        sut.repos = [repo1, repo1, repo1]
        
        XCTAssertTrue(sut.isNoResultsFoundLabelHidden(),
                      "isNoResultsFoundLabelHidden() when repos array is not empty should return true but returned false")
    }
    
    func testIsNoResultsFoundLabelHidden_whenReposEmpty_returnsFalse() {
        sut.repos = []
        
        XCTAssertFalse(sut.isNoResultsFoundLabelHidden(),
                       "isNoResultsFoundLabelHidden() when repos array is empty should return false but returned true")
    }
    
    // MARK: numberOfRowsInSection()
    func testNumberOfRowsInSection_whenReposIsNil_returnsZero() {
        sut.repos = nil
        
        XCTAssertEqual(sut.numberOfRowsInSection(), 0,
                       "numberOfRowsInSection() when repos is nil should return 0 but it didn't")
    }
    
    func testNumberOfRowsInSection_whenReposIsNotNil_returnsNumberOfElements() {
        sut.repos = [repo1, repo1, repo1]
        
        XCTAssertEqual(sut.numberOfRowsInSection(), 3,
                       "numberOfRowsInSection() returned wrong number of elements when repos is not nil.")
    }
    
    // MARK: repoForRowAt(indexPath: IndexPath)
    func testRepoForRowAt_whenReposNotNil_returnsCorrectRepo() {
        sut.repos = [repo1, repo2]
        let indexPath = IndexPath(row: 0, section: 0)
        let repo = sut.repoForRowAt(indexPath: indexPath)
        
        XCTAssertEqual(repo?.repoId, sut.repos?[indexPath.row].repoId,
                       "repoForRowAt() returned wrong repo for indexPath")
    }
    
    func testRepoForRowAt_whenReposNil_returnsNil() {
        sut.repos = nil
        let indexPath = IndexPath(row: 0, section: 0)
        let repo = sut.repoForRowAt(indexPath: indexPath)
        
        XCTAssertNil(repo, "repoForRowAt() did not return nil when repos array is nil")
    }
    
    func testRepoForRowAt_whenLastRowAndTotalGreaterThanReposCount_incrementsPageByOne() {
        
        sut.totalRepos = 3
        
        sut.repos = [repo1, repo2]
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        _ = sut.repoForRowAt(indexPath: indexPath)
        
        XCTAssertEqual(sut.page, 2,
                       "repoForRowAt() did not increment page by one")
    }
    
    func testRepoForRowAt_whenLastRowAndTotalGreaterThanReposCount_setsShouldScrollToTopToFalse() {
        sut.totalRepos = 3
        sut.repos = [repo1, repo2]
        let indexPath = IndexPath(row: 1, section: 0)
        
        _ = sut.repoForRowAt(indexPath: indexPath)
        
        XCTAssertFalse(sut.shouldScrollToTop,
                       "repoForRowAt() did not set shouldScrollToTop to false")
    }
    func testRepoForRowAt_whenLastRowAndTotalGreaterThanReposCount_callsShowLoader() {
        sut.totalRepos = 3
        sut.repos = [repo1, repo2]
        let indexPath = IndexPath(row: 1, section: 0)
        
        _ = sut.repoForRowAt(indexPath: indexPath)
        
        XCTAssertTrue(mockView.showLoaderCalled,
                      "repoForRowAt() did not call showLoader()")
    }
    func testRepoForRowAt_whenLastRowAndTotalGreaterThanReposCount_callsLoadRepos() {sut.interactor = mockInteractor
        sut.totalRepos = 3
        sut.repos = [repo1, repo2]
        let indexPath = IndexPath(row: 1, section: 0)
        
        _ = sut.repoForRowAt(indexPath: indexPath)
        
        XCTAssertTrue(mockInteractor.loadReposCalled,
                      "repoForRowAt() did not call loadRepos()")
    }
    
    // MARK: updateSearchResults(withQuery query: String)
    func testUpdateSearchResults_whenCalledWithQuery_setsSearchBarQuery() {sut.interactor = mockInteractor
        let testQuery = "test query"
        sut.updateSearchResults(withQuery: testQuery)
        
        XCTAssertEqual(sut.searchBarQuery, testQuery)
    }
    
    func testUpdateSearchResults_whenCalled_setsPageToOne() {sut.interactor = mockInteractor
        let testQuery = "test query"
        sut.updateSearchResults(withQuery: testQuery)
        
        XCTAssertEqual(sut.page, 1)
    }
    
    func testUpdateSearchResults_whenCalled_setsShouldScrollToTopToTrue() {sut.interactor = mockInteractor
        let testQuery = "test query"
        sut.updateSearchResults(withQuery: testQuery)
        
        XCTAssertTrue(sut.shouldScrollToTop)
    }
    
    // MARK: fetchReposSuccess(repos: [Repo], forQuery query: String, total: Int)
    func testFetchReposSuccess_whenItIsFirstPage_replacesReposWithNewResults() {
        let repos = [repo1!, repo2!]
        
        sut.fetchReposSuccess(repos: repos, forQuery: "test", total: 2)
        
        XCTAssertNotNil(sut.repos,
                        "repos is nil when fetchReposSuccess was supposed to set it with a new value")
        XCTAssertEqual(sut.repos?.count, repos.count,
                       "the number of elements in repos != number of elements in the repos with new result")
        for (index, repo) in (sut.repos?.enumerated())! {
            XCTAssertEqual(repo.repoId, repos[index].repoId,
                           "Elements of repos are not the same as elements in the repos with new result")
        }
    }
    
    func testFetchReposSuccess_whenItIsFirstPage_replacesTotalReposWithNewNumber() {
        let total = 2
        
        sut.fetchReposSuccess(repos: [], forQuery: "test", total: total)
        
        XCTAssertEqual(sut.totalRepos, total)
    }
    
    func testFetchReposSuccess_whenItIsFirstPage_replacesQueryForDisplayedRepos() {
        let query = "test"
        
        sut.fetchReposSuccess(repos: [], forQuery: query, total: 2)
        
        XCTAssertEqual(sut.queryForDisplayedRepos, query)
    }
    
    func testFetchReposSuccess_whenTotalIsZero_setsShouldScrollToTopToFalse() {
        let total = 0
        
        sut.fetchReposSuccess(repos: [], forQuery: "test", total: total)
        
        XCTAssertFalse(sut.shouldScrollToTop)
    }
    
    func testFetchReposSuccess_whenItIsNotFirstPage_appendRepos() {
        sut.page = 2
        
        sut.repos = [repo1!]
        let expected = [repo1!, repo2!]
        
        sut.fetchReposSuccess(repos: [repo2], forQuery: "test", total: 2)
        
        XCTAssertNotNil(sut.repos,
                        "repos is nil when fetchReposSuccess was supposed to set it with a new value")
        XCTAssertEqual(sut.repos?.count, expected.count,
                       "the number of elements in repos != number of elements in the repos with new result")
        for (index, repo) in (sut.repos?.enumerated())! {
            XCTAssertEqual(repo.repoId, expected[index].repoId,
                           "Elements of repos are not the same as elements in the repos with new result")
        }
    }
    
    func testFetchReposSuccess_whenCalled_callsHideLoader() {
        sut.fetchReposSuccess(repos: [], forQuery: "test", total: 2)
        
        XCTAssertTrue(mockView.hideLoaderCalled,
                      "fetchReposSuccess didn't call hideLoader()")
    }
    
    func testFetchReposSuccess_whenCalled_callsOnFetchReposSuccess() {
        sut.fetchReposSuccess(repos: [], forQuery: "test", total: 2)
        
        XCTAssertTrue(mockView.onFetchReposSuccessCalled,
                      "fetchReposSuccess didn't call onFetchReposSuccess()")
    }
    
    // MARK: fetchReposFailure(errorCode: Int)
    func testFetchReposFailure_whenCalled_callsHideLoader() {
        sut.fetchReposFailure(errorCode: 0)
        
        XCTAssertTrue(mockView.hideLoaderCalled,
                      "fetchReposFailure didn't call hideLoader()")
    }
    
    func testFetchReposFailure_whenCalled_callsOnFetchReposFailure() {
        sut.fetchReposFailure(errorCode: 0)
        
        XCTAssertTrue(mockView.onFetchReposFailureCalled,
                      "fetchReposFailure didn't call onFetchReposFailure")
    }
}
