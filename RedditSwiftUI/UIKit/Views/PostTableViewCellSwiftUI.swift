//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Володимир on 17.03.2025.
//

import Foundation
import UIKit
import SDWebImage
import SwiftUI

class PostTableViewCellSwiftUI: PostTableViewCell {
    var hostingViewController: UIViewController = UIViewController()
    var parent: UIViewController? = UIViewController()
    
    override func config(with post: Post, _ parent: PostListViewController?){
        self.parent = parent
        url = post.url
        //postView.config(with: post, parentCell: self)
        integrate(post)
        //postHeightConstraint.constant = 100
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //postView.reuse()
        
        hostingViewController.didMove(toParent: nil)
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        parent = nil
    }
    
    func integrate(_ post: Post){
        // 1. Embed SwiftUI view in UIHostingController
        hostingViewController = UIHostingController(rootView: SavedPostView(post: post))

        // 2. Get reference to the HostingController view (UIView)
        let swiftUIView: UIView = hostingViewController.view

        // 3. Put `swiftUIView` in `containerView`
        self.contentView.addSubview(swiftUIView)

        // 4. Layout with constraints
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        ])

        // 5. Notify child View Controller of being presented
        hostingViewController.didMove(toParent: parent)
    }
}
