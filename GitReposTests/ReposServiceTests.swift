//
//  ReposServiceTests.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import XCTest
@testable import GitRepos

class ReposServiceTests: XCTestCase {

    var urlSession: URLSession!
    var sut: ReposService!
    var mockUsersService: MockUsersService!
    var testBundle: Bundle!
    var fetchedReposExpectation: XCTestExpectation!
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "MockReposSearchResponse",
                                           withExtension: "json") else { fatalError() }
        
        let jsonData = try? Data(contentsOf: fileURL)
        MockURLProtocol.testData = jsonData
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        urlSession = URLSession(configuration: config)
        
        mockUsersService = MockUsersService()
        sut = ReposService(urlSession: urlSession, usersService: mockUsersService)
        
        fetchedReposExpectation = expectation(description: "Repos fetched.")
    }

    override func tearDown() {
        urlSession = nil
        sut = nil
        mockUsersService = nil
        MockURLProtocol.testData = nil
        fetchedReposExpectation = nil
    }

    func testFetchReposCallsFetchFollowersForUser() {
        sut.fetchRepos(withQuery: "test", page: 1) { _ in
            XCTAssertTrue(self.mockUsersService.fetchFollowersForUserCalled,
                          "fetchRepos didn't call fetchFollowersForUser")
            self.fetchedReposExpectation.fulfill()
        }
        wait(for: [fetchedReposExpectation], timeout: 1)
    }

    func testFetchReposReturnsCorrectTotalCount() {
        sut.fetchRepos(withQuery: "test", page: 1) { result in
            switch result {
            case .success(_, let totalCount):
                XCTAssertEqual(totalCount, 70, "fetchRepos returned wrong totalCount")
            case .failure:
                XCTFail("fetchRepos returned failure when it was expecter to return success.")
            }
            self.fetchedReposExpectation.fulfill()
        }
        wait(for: [fetchedReposExpectation], timeout: 1)
    }
    
    func testFetchReposReturnsCorrectNumberOfRepos() {
        sut.fetchRepos(withQuery: "test", page: 1) { result in
            switch result {
            case .success(let repos, _):
                XCTAssertEqual(repos.count, 3, "fetchRepos returned repos with wrong number of elements")
            case .failure:
                XCTFail("fetchRepos returned failure when it was expecter to return success.")
            }
            self.fetchedReposExpectation.fulfill()
        }
        wait(for: [fetchedReposExpectation], timeout: 1)
    }
    
    func testFetchReposReturnsFailureWithCanNotProcessDataError() {
        MockURLProtocol.testData = Data()
        
        sut.fetchRepos(withQuery: "test", page: 1) { result in
            switch result {
            case .success:
                XCTFail("fetchRepos returned success when it was expected to return failure.")
            case .failure(let error):
                XCTAssertEqual(error, FetchingError.canNotProcessData,
                               "fetchRepos returned wrong error type")
            }
            self.fetchedReposExpectation.fulfill()
        }
        wait(for: [fetchedReposExpectation], timeout: 1)
    }
    
    func testFetchReposReturnsFailureWithErrorFetchingData() {
        MockURLProtocol.fetchingError = FetchingError.errorFetchingData
        
        sut.fetchRepos(withQuery: "test", page: 1) { result in
            switch result {
            case .success:
                XCTFail("fetchRepos returned success when it was expected to return failure.")
            case .failure(let error):
                XCTAssertEqual(error, FetchingError.errorFetchingData,
                               "fetchRepos returned wrong error type")
            }
            self.fetchedReposExpectation.fulfill()
        }
        wait(for: [fetchedReposExpectation], timeout: 1)
    }
}
