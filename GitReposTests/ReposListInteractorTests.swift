//
//  ReposListInteractorTests.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import XCTest
@testable import GitRepos

class ReposListInteractorTests: XCTestCase {
    
    var sut: ReposListInteractor!
    var mockPresenter: MockReposListPresenter!
    var mockReposService: MockReposService!

    override func setUp() {
        sut = ReposListInteractor()
        mockPresenter = MockReposListPresenter()
        mockReposService = MockReposService()
        
        sut.presenter = mockPresenter
        sut.reposService = mockReposService
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockReposService = nil
    }

    func testLoadRepos_whenReposServiceDidNotReturnError_fetchReposSucessCalled() {
        sut.loadRepos(withQuery: "test", page: 1)

        XCTAssertTrue(mockPresenter.fetchReposSuccessCalled,
                      "loadRepos didn't call fetchReposSuccess when there was no error from the ReposService")
    }
    
    func testLoadRepos_whenReposServiceReturnsError_fetchReposFailureCalled() {
        mockReposService.mockFetchingError = .errorFetchingData

        sut.loadRepos(withQuery: "test", page: 1)

        XCTAssertTrue(mockPresenter.fetchReposFailureCalled,
                      "loadRepos didn't call fetchReposFailure when ReposService returned error")
    }

}
