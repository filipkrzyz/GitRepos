//
//  ReposListInteractor.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

class ReposListInteractor: PresenterToInteractorReposListProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterReposListProtocol?
    var reposService: ReposServiceProtocol? = ReposService.shared
    
    // MARK: Interactor Input (Presenter -> Interactor)
    func loadRepos(withQuery query: String, page: Int) {
        
        reposService?.fetchRepos(withQuery: query, page: page) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.fetchReposFailure(errorCode: 0)
            case .success(let repos, let total):
                self?.presenter?.fetchReposSuccess(repos: repos, forQuery: query, total: total)
            }
        }
    }
}
