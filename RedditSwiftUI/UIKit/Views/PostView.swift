import UIKit

class PostView: UIView {
    //MARK: - Constructors
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("PostView", owner: self, options: nil)?.first as! UIView
        
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    //MARK: - Outlets
    @IBOutlet internal weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet internal weak var postImageView: UIImageView!
    @IBOutlet internal weak var bookmarkReactionView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentCountLabel: UILabel!
    @IBOutlet private weak var shareStackView: UIStackView!
    @IBOutlet private weak var imageWrapperHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Other variables
    private var url: URL? = nil
    private var isSaved: Bool = false
    private var parentCell: PostTableViewCellUIKit?
    private var withImage: Bool = true
    
    func config(with post: Post){
        url = post.url
        authorLabel.text = post.author
        timeLabel.text = post.date
        domainLabel.text = post.domain
        titleLabel.text = post.title
        
        if (post.imagePath == nil && post.imageURL == nil){
            withImage = false
        }
        
        ratingLabel.text = "\((post.upvotes ?? 0) - (post.downvotes ?? 0))"
        commentCountLabel.text = "\(post.commentCount ?? 0)"
        
        if let height = post.imageHeight{
            imageWrapperHeightConstraint.constant = CGFloat(height > 170 ? 170 : height)
            parentCell?.postHeightConstraint.constant = 300
        } else{
            imageWrapperHeightConstraint.constant = 0
            parentCell?.postHeightConstraint.constant = 130
        }
        
        if(post.isLocal){
            guard let path = post.imagePath else { return }
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imagePath = documentsDirectory.appendingPathComponent(path).relativePath
            postImageView.image = PostService.loadImageFromPath(imagePath)
            print("loading local image from path: \(imagePath)")

            imageWrapperHeightConstraint.constant = 150
            parentCell?.postHeightConstraint.constant = 300
        } else {
            postImageView.sd_setImage(with: post.imageURL)
        }
        
        isSaved = post.saved
        bookmarkButton.setImage(UIImage(systemName: post.saved ? "bookmark.fill" : "bookmark"), for: .normal)
        
        
        //TODO: ??
        if parentCell != nil {
            shareStackView.addGestureRecognizer(parentCell!.shareTapRecognizer)
            bookmarkButton.addGestureRecognizer(parentCell!.bookmarkTapRecognizer)
        }
    }
    
    func config(with post: Post, parentCell: PostTableViewCellUIKit?){
        config(with: post)
        self.parentCell = parentCell
    }
    
    func reuse(){
        postImageView.image = nil
        postImageView.sd_cancelCurrentImageLoad()
        bookmarkReactionView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        authorLabel.text = nil
        timeLabel.text = nil
        domainLabel.text = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        authorLabel.text = nil
        imageWrapperHeightConstraint.constant = 0
        isSaved = false
        url = nil
        withImage = true
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
}
