import UIKit
import SDWebImage


class PostDetailsViewController: UIViewController {
    @IBOutlet weak var postView: PostView!
    
    private var post: Post?

    func config(_ post: Post) {
        self.post = post
        if isViewLoaded {
            postView.config(with: post)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            postView.config(with: post)
        }
    }
}
