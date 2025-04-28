//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Володимир on 17.03.2025.
//

import Foundation
import UIKit
import SDWebImage

class PostTableViewCellUIKit: PostTableViewCell {
    @IBOutlet internal weak var postView: PostView!
    @IBOutlet weak var postHeightConstraint: NSLayoutConstraint!
    
    override func config(with post: Post, _ parent: PostListViewController?){
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
