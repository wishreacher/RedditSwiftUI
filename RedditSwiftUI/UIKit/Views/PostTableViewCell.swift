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
    //MARK: - Other variables
    var parentViewController: PostListViewController?
    internal var isSaved: Bool = false
    internal var url: URL?
    
    func config(with post: Post, _ parent: PostListViewController?){

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
