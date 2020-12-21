//
//  ReposListViewController.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import JGProgressHUD

private let repoCellReuseIdentifier = "RepoCell"

class ReposListViewController: UITableViewController {

    // MARK: - Properties
    var presenter: ViewToPresenterReposListProtocol?
    
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private weak var startTypingView: UIView!
    @IBOutlet private weak var noReposFoundLabel: UILabel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let hud = JGProgressHUD()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ReposListRouter.createReposListModule(reposListViewController: self)
        
        startTypingView.isHidden = false
        noReposFoundLabel.isHidden = self.presenter?.isNoResultsFoundLabelHidden() ?? true
        
        configureNavigationController()
        configureTableView()
        configureHUD()
        configureSearchController()
    }
    
    // MARK: UI Setup
    
    func configureHUD() {
        hud.textLabel.text = "Loading"
        hud.style = .dark
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundView = backgroundView
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = .gitBackgroundDark
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "GitRepos_top"))
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a repository"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
}

// MARK: - View Output

extension ReposListViewController: PresenterToViewReposListProtocol {
    func onFetchReposSuccess() {
        DispatchQueue.main.async {
            self.startTypingView.isHidden = true
            self.noReposFoundLabel.isHidden = self.presenter?.isNoResultsFoundLabelHidden() ?? true
            if self.presenter?.shouldScrollToTop ?? false {
                self.scrollToTop()
            }
            self.tableView.reloadData()
        }
    }
    
    func onFetchReposFailure(error: String) {
        DispatchQueue.main.async {
            self.noReposFoundLabel.isHidden = self.presenter?.isNoResultsFoundLabelHidden() ?? true
            self.tableView.reloadData()
        }
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.hud.dismiss()
        }
    }
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate/DataSource

extension ReposListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: repoCellReuseIdentifier,
                                                       for: indexPath) as? RepoCell else {
            fatalError("Wrong cell type")
        }
        cell.repo = presenter?.repoForRowAt(indexPath: indexPath)
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension ReposListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.lowercased()
        if query != "" {
            presenter?.updateSearchResults(withQuery: query)
        }
    }
}
