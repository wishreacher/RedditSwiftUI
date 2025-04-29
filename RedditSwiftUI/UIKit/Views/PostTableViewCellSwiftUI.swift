import Foundation
import UIKit
import SDWebImage
import SwiftUI

class PostTableViewCellSwiftUI: PostTableViewCell {
    var hostingViewController: UIViewController = UIViewController()
    var post: Post = Post()
    
    override func config(with post: Post, _ parent: PostListViewController?){
        super.config(with: post, parent)
        self.post = post
        parentViewController = parent
        url = post.url
        integrate(post)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hostingViewController.didMove(toParent: nil)
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        parentViewController = nil
    }
    
    func integrate(_ post: Post){
        hostingViewController = UIHostingController(rootView: SavedPostView(post: post))

        let swiftUIView: UIView = hostingViewController.view

        self.contentView.addSubview(swiftUIView)

        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        ])

        hostingViewController.didMove(toParent: parentViewController)
    }
    
    override func didTapOnPost() {
        if parentViewController == nil {
            print("no parent controller")
        }
        parentViewController?.performSegue(withIdentifier: "go_to_post", sender: nil)
    }
    
    override func didDoubleTapOnPost() {
        parentViewController?.bookmarkPost(in: self)
        PostService.deletePost(post, from: PostService.getPathInDocumentsDirectory(withFileName: "posts"))
        parentViewController?.reloadTable()
    }
}
