//
//  MockURLProtocol.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 21/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
@testable import GitRepos

class MockURLProtocol: URLProtocol {
    static var testData: Data? = Data()
    static var fetchingError: FetchingError?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        
        if let error = MockURLProtocol.fetchingError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let data = MockURLProtocol.testData {
                self.client?.urlProtocol(self, didLoad: data)
            } 
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
