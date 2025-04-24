//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Володимир on 17.03.2025.
//

import Foundation
import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    //MARK: - Outlets
    
    @IBOutlet private weak var postView: PostView!
    @IBOutlet weak var postHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Other variables
    var parentViewController: PostListViewController?
    private var isSaved: Bool = false
    private var url: URL?
    
    func config(with post: Post, _ parent: PostListViewController?){
        parentViewController = parent
        url = post.url
        postView.config(with: post, parentCell: self)
        
        postHeightConstraint.constant = 100
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postView.reuse()
    }
}
