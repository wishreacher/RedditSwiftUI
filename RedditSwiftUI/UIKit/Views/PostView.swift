//
//  Post.swift
//  Reddit
//
//  Created by Володимир on 31.03.2025.
//

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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var bookmarkReactionView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentCountLabel: UILabel!
    @IBOutlet private weak var shareStackView: UIStackView!
    @IBOutlet private weak var imageWrapperHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Other variables
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
    lazy var shareTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapShareButton))
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    lazy var bookmarkTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBookmarkButton))
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    private var url: URL? = nil
    private var isSaved: Bool = false
    private var parentCell: PostTableViewCell?
    private var withImage: Bool = false
    
    func config(with post: Post){
        url = post.url
        authorLabel.text = post.author
        timeLabel.text = post.date
        domainLabel.text = post.domain
        titleLabel.text = post.title
        postImageView.sd_setImage(with: post.imageURL)
        
        //TODO: can it lead to problems??
        
        ratingLabel.text = "\(post.upvotes! - post.downvotes!)"
        commentCountLabel.text = "\(post.commentCount!)"
        
        if let height = post.imageHeight{
            imageWrapperHeightConstraint.constant = CGFloat(height > 170 ? 170 : height)
            parentCell?.postHeightConstraint.constant = 300
            withImage = true
        } else{
            imageWrapperHeightConstraint.constant = 0
            parentCell?.postHeightConstraint.constant = 130
            withImage = false
        }
        isSaved = post.saved
        bookmarkButton.setImage(UIImage(systemName: post.saved ? "bookmark.fill" : "bookmark"), for: .normal)
        
        self.addGestureRecognizer(doubleTapRecognizer)
        self.addGestureRecognizer(singleTapRecognizer)
        shareStackView.addGestureRecognizer(shareTapRecognizer)
        bookmarkButton.addGestureRecognizer(bookmarkTapRecognizer)
    }
    
    func config(with post: Post, parentCell: PostTableViewCell?){
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
        withImage = false
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
    
    //MARK: - tap gestures handlers
    @objc
    func didDoubleTapOnPost() {
        parentCell?.parentViewController?.bookmarkPost(in: parentCell!)
        isSaved.toggle()
        
        if postImageView.image == nil {
            parentCell?.parentViewController?.reloadTable()
            return
        }
        drawBookmark(in: bookmarkReactionView)
        
        if isSaved {
            onBookmarkAppear(view: bookmarkReactionView)
        } else {
            onBookmarkDisappear(view: bookmarkReactionView)
        }
    }
    
    @objc
    func didTapOnPost() {
        parentCell?.parentViewController?.performSegue(withIdentifier: "go_to_post", sender: nil)
    }
    
    @objc
    func didTapShareButton(){
        let avc = UIActivityViewController(activityItems: ["\(titleLabel.text): \(String(describing: self.url))"], applicationActivities: nil)
        parentCell?.parentViewController?.present(avc, animated: true)
    }
    
    @objc
    func didTapBookmarkButton(){
        parentCell?.parentViewController?.bookmarkPost(in: parentCell!)
        parentCell?.parentViewController?.reloadTable()
    }
    
    //MARK: - bookmark animation
    
    private func drawBookmark(in view: UIView) {
        let width: CGFloat = 50
        let height: CGFloat = 80

        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let path = UIBezierPath()

        path.move(to: CGPoint(x: view.frame.midX - width / 2,
                              y: (view.frame.midY / 2)))
        path.addLine(to: CGPoint(x: view.frame.midX + width / 2,
                                 y: (view.frame.midY / 2)))
        path.addLine(to: CGPoint(x: view.frame.midX + width / 2,
                                 y: (view.frame.midY / 2) + height))
        path.addLine(to: CGPoint(x: view.frame.midX,
                                 y: (view.frame.midY / 2) + height * 0.7))
        path.addLine(to: CGPoint(x: view.frame.midX - width / 2,
                                 y: (view.frame.midY / 2) + height))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1).cgColor
        shapeLayer.lineWidth = 1
        
        shapeLayer.cornerRadius = 10
        shapeLayer.cornerCurve = .continuous

        view.layer.addSublayer(shapeLayer)
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
                self.parentCell?.parentViewController?.reloadTable()
                view.layer.sublayers?.removeAll()
            }
        }
    }
    
    func onBookmarkDisappear(view: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            self.bookmarkReactionView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { _ in
            self.bookmarkReactionView.transform = .identity
            
            self.parentCell?.parentViewController?.reloadTable()
            view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
    }
}
