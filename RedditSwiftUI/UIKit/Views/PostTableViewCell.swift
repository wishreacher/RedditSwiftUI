import Foundation
import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    var parentViewController: PostListViewController?
    internal var isSaved: Bool = false
    internal var url: URL?
    
    lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapOnPost))
        
        tapRecognizer.numberOfTapsRequired = 2
        
        return tapRecognizer
    }()
    lazy var singleTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnPost))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.require(toFail: doubleTapRecognizer)
        return tapRecognizer
    }()
    
    
    func config(with post: Post, _ parent: PostListViewController?){
        self.addGestureRecognizer(doubleTapRecognizer)
        self.addGestureRecognizer(singleTapRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    @objc
    func didDoubleTapOnPost() {
        
    }
    
    @objc
    func didTapOnPost() {
        if parentViewController == nil {
            print("no parent controller")
        }
        parentViewController?.performSegue(withIdentifier: "go_to_post", sender: nil)
    }
    
    func onBookmarkAppear(view: UIView){
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut) {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                view.transform = .identity
            } completion: { _ in
                self.parentViewController?.reloadTable()
                view.layer.sublayers?.removeAll()
            }
        }
    }
    
    func onBookmarkDisappear(view: UIView){

    }
}
