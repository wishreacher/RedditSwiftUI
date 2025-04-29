import Foundation
import UIKit
import SDWebImage

class PostTableViewCellUIKit: PostTableViewCell {
    @IBOutlet internal weak var postView: PostView!
    @IBOutlet weak var postHeightConstraint: NSLayoutConstraint!
    
    lazy var bookmarkTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBookmarkButton))
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    lazy var shareTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapShareButton))
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    override func config(with post: Post, _ parent: PostListViewController?){
        super.config(with: post, parent)
        parentViewController = parent
        url = post.url
        postView.config(with: post, parentCell: self)
        
        postHeightConstraint.constant = 100
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postView.reuse()
    }
    
    override func didDoubleTapOnPost() {
        parentViewController?.bookmarkPost(in: self)
        isSaved.toggle()
        
        if postView?.postImageView.image == nil {
            parentViewController?.reloadTable()
            return
        }
        Drawing.drawBookmark(in: postView.bookmarkReactionView)
        
        if isSaved {
            onBookmarkAppear(view: postView.bookmarkReactionView)
        } else {
            onBookmarkDisappear(view: postView.bookmarkReactionView)
        }
    }
    
    override func onBookmarkDisappear(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.postView?.bookmarkReactionView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { _ in
            self.postView?.bookmarkReactionView.transform = .identity
            
            self.parentViewController?.reloadTable()
            view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
    }
    
    @objc
    func didTapShareButton(){
        let avc = UIActivityViewController(activityItems: ["\(postView.titleLabel.text): \(String(describing: self.url))"], applicationActivities: nil)
        parentViewController?.present(avc, animated: true)
    }
    
    @objc
    func didTapBookmarkButton(){
        parentViewController?.bookmarkPost(in: self)
        parentViewController?.reloadTable()
    }
}
