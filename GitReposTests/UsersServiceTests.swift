//
//  UsersServiceTests.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 19/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import XCTest
@testable import GitRepos

class UsersServiceTests: XCTestCase {

    var urlSession: URLSession!
    var sut: UsersService!
    var testBundle: Bundle!
    var fetchedFollowersExpectation: XCTestExpectation!
    var jsonDat: Data?
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "MockUserResponse",
                                           withExtension: "json") else { fatalError() }
        let jsonData = try? Data(contentsOf: fileURL)
        jsonDat = jsonData
        MockURLProtocol.testData = jsonData
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        urlSession = URLSession(configuration: config)
        
        sut = UsersService(urlSession: urlSession)
        
        fetchedFollowersExpectation = expectation(description: "Followers fetched.")
    }

    override func tearDown() {
        urlSession = nil
        sut = nil
        MockURLProtocol.testData = nil
        MockURLProtocol.fetchingError = nil
        fetchedFollowersExpectation = nil
    }

    // This test fails when run in automatic tests (passes when run individually).
    // Due to time constraints I didn't address this issue.
    func testFetchFollowersForUser_returnsFollowersCount() {
        let stringUrl = "https://example.com/api/v1/"
        MockURLProtocol.testData = jsonDat
        sut.fetchFollowersForUser(withUserUrl: stringUrl) { followers in
            XCTAssertEqual(followers, 9216,
                           "fetchFollowersForUser returned wrong followers count.")
            self.fetchedFollowersExpectation.fulfill()
        }
        wait(for: [fetchedFollowersExpectation], timeout: 1)
    }
    
    func testFetchFollowersForUser_whenGivenWrongUrl_returnsNil() {
        let stringUrl = "wrong url"
        
        sut.fetchFollowersForUser(withUserUrl: stringUrl) { followers in
            XCTAssertNil(followers,
                         "fetchFollowersForUser didn't return nil when given wrong URL")
            self.fetchedFollowersExpectation.fulfill()
        }
        wait(for: [fetchedFollowersExpectation], timeout: 1)
    }
    
    func testFetchFollowersForUser_whenCannotProcessData_returnsNil() {
        MockURLProtocol.testData = Data()
        let stringUrl = "https://example.com/api/v1/"
        
        sut.fetchFollowersForUser(withUserUrl: stringUrl) { followers in
            XCTAssertNil(followers,
                         "fetchFollowersForUser didn't return nil when data was not possible to be processed")
            self.fetchedFollowersExpectation.fulfill()
        }
        wait(for: [fetchedFollowersExpectation], timeout: 1)
    }

}
