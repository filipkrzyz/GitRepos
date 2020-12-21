//
//  ReposListPresenter.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

class ReposListPresenter: ViewToPresenterReposListProtocol {
    
    // MARK: Properties
    var view: PresenterToViewReposListProtocol?
    var interactor: PresenterToInteractorReposListProtocol?
    var router: PresenterToRouterReposListProtocol?
    
    var repos: [Repo]?
    var searchBarQuery = ""
    var queryForDisplayedRepos = ""
    var page: Int = 1
    var totalRepos: Int = 0
    
    var shouldScrollToTop: Bool = false
    
    var searchTask: DispatchWorkItem?
    
    // MARK: Inputs from view
    func isNoResultsFoundLabelHidden() -> Bool {
        return self.repos?.count != 0
    }
    
    func numberOfRowsInSection() -> Int {
        guard let repos = self.repos else {
            return 0
        }
        return repos.count
    }
    
    func repoForRowAt(indexPath: IndexPath) -> Repo? {
        guard let repos = self.repos else {
            return nil
        }
        
        if indexPath.row == repos.count - 1 {
            if totalRepos > repos.count {
                self.page += 1
                self.shouldScrollToTop = false
                view?.showLoader()
                interactor?.loadRepos(withQuery: self.queryForDisplayedRepos, page: self.page)
            }
        }
        return repos[indexPath.row]
    }

    func updateSearchResults(withQuery query: String) {
        
        self.searchBarQuery = query
        self.page = 1
        self.shouldScrollToTop = true
        
        self.searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.view?.showLoader()
            self?.interactor?.loadRepos(withQuery: query, page: self?.page ?? 1)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}

// MARK: - Outputs to view
extension ReposListPresenter: InteractorToPresenterReposListProtocol {
    func fetchReposSuccess(repos: [Repo], forQuery query: String, total: Int) {
        if self.page == 1 {
            self.repos = repos
            self.totalRepos = total
            self.queryForDisplayedRepos = query
            if total == 0 { self.shouldScrollToTop = false }
        } else {
            self.repos?.append(contentsOf: repos)
        }
        
        view?.hideLoader()
        view?.onFetchReposSuccess()
    }
    
    func fetchReposFailure(errorCode: Int) {
        view?.hideLoader()
        view?.onFetchReposFailure(error: "Couldn't fetch repos: \(errorCode)")
    }
}
