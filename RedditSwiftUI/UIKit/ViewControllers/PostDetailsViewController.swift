import UIKit
import SDWebImage


class PostDetailsViewController: UIViewController {
    @IBOutlet weak var postView: PostView!
    
    private var post: Post?
    private var parentCell: PostTableViewCell?

    func config(_ post: Post, parentCell: PostTableViewCell?) {
        self.post = post
        self.parentCell = parentCell
//        if isViewLoaded {
//            postView.config(with: post, parentCell: parentCell)
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            postView.config(with: post, parentCell: parentCell)
        }
    }
}
