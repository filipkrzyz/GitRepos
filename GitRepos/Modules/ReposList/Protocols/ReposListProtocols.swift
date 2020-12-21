//
//  ReposListProtocols.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewReposListProtocol: class {
    func onFetchReposSuccess()
    func onFetchReposFailure(error: String)
    func showLoader()
    func hideLoader()
    func scrollToTop()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterReposListProtocol: class {

    var view: PresenterToViewReposListProtocol? { get set }
    var interactor: PresenterToInteractorReposListProtocol? { get set }
    var router: PresenterToRouterReposListProtocol? { get set }
    var repos: [Repo]? { get set }
    var searchBarQuery: String { get set }
    var queryForDisplayedRepos: String { get set }
    var page: Int { get set }
    var totalRepos: Int { get set }
    var shouldScrollToTop: Bool { get set }
    var searchTask: DispatchWorkItem? { get set }
    
    func isNoResultsFoundLabelHidden() -> Bool
    func numberOfRowsInSection() -> Int
    func repoForRowAt(indexPath: IndexPath) -> Repo?
    func updateSearchResults(withQuery query: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorReposListProtocol: class {

    var presenter: InteractorToPresenterReposListProtocol? { get set }
    var reposService: ReposServiceProtocol? { get set }

    func loadRepos(withQuery query: String, page: Int)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterReposListProtocol: class {

    func fetchReposSuccess(repos: [Repo], forQuery: String, total: Int)
    func fetchReposFailure(errorCode: Int)

}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterReposListProtocol: class {

    static func createReposListModule(reposListViewController: ReposListViewController)

}
