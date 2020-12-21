//
//  RepoCell.swift
//  GitRepos
//
//  Created by Filip Krzyzanowski on 15/12/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import SDWebImage

class RepoCell: UITableViewCell {

    // MARK: Properties
    var repo: Repo? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var watchersView: UIView!
    @IBOutlet private weak var followersView: UIView!
    @IBOutlet private weak var forksView: UIView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        profileImageView.layer.cornerRadius = 48 / 2
        
        selectionStyle = .none
    }
    
    // MARK: Configure UI
    func configure() {
        nameLabel.text = repo?.fullName
        descriptionLabel.text = repo?.description
        watchersLabel.text = (repo?.watchersCount ?? 0).formatUsingAbbreviation()
        followersLabel.text = (repo?.gitUser.followersCount ?? 0).formatUsingAbbreviation()
        forksLabel.text = (repo?.forksCount ?? 0).formatUsingAbbreviation()
        watchersView.isHidden = repo?.watchersCount ?? 0 == 0
        followersView.isHidden = repo?.gitUser.followersCount ?? 0 == 0
        forksView.isHidden = repo?.forksCount ?? 0 == 0
        
        guard let url = URL(string: repo?.gitUser.avatarUrl ?? "") else { return }
        profileImageView.sd_setImage(with: url)
    }
}
