//
//  IntExtensionsTests.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 20/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import XCTest
@testable import GitRepos

class IntExtensionsTests: XCTestCase {
    
    func testFormatUsingAbbreviation_returnsCorrectAbbrevation() {
        let testValue: [Int] = [598, -999, 1000, -1284, 9940, 9980, 39900,
                                99880, 399880, 999898, 999999, 1456384, 12383474]
        let expected: [String?] = ["598", "-999", "1K", "-1.3K", "9.9K", "10K", "39.9K",
                                  "99.9K", "0.4M", "1M", "1M", "1.5M", "12.4M"]

        var formatted: [String?] = []
        
        testValue.forEach {
            formatted.append($0.formatUsingAbbreviation())
        }
        
        XCTAssertEqual(formatted, expected)
    }
}
