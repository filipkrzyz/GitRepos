//
//  MockReposListViewController.swift
//  GitReposTests
//
//  Created by Filip Krzyzanowski on 20/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
@testable import GitRepos

class MockReposListViewController: PresenterToViewReposListProtocol {
    
    var onFetchReposSuccessCalled = false
    var onFetchReposFailureCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    var scrollToTopCalled = false
    
    func onFetchReposSuccess() {
        onFetchReposSuccessCalled = true
    }
    
    func onFetchReposFailure(error: String) {
        onFetchReposFailureCalled = true
    }
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader() {
        hideLoaderCalled = true
    }
    
    func scrollToTop() {
        scrollToTopCalled = true
    }
}
