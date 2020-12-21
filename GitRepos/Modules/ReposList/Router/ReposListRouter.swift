//
//  ReposListRouter.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import UIKit

class ReposListRouter: PresenterToRouterReposListProtocol {

    class func createReposListModule(reposListViewController: ReposListViewController) {
        
        let presenter: ViewToPresenterReposListProtocol & InteractorToPresenterReposListProtocol = ReposListPresenter()
        
        reposListViewController.presenter = presenter
        reposListViewController.presenter?.router = ReposListRouter()
        reposListViewController.presenter?.view = reposListViewController
        reposListViewController.presenter?.interactor = ReposListInteractor()
        reposListViewController.presenter?.interactor?.presenter = presenter
    }
}
