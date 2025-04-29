import Foundation
import UIKit

enum PostListViewState{
    case normal
    case displaySaved
    case filtered
}

class PostListViewController: UITableViewController, UITextFieldDelegate{
    //MARK: - Outlets
    @IBOutlet private weak var domainName: UINavigationItem!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var notFoundLabel: UILabel!
    
    @IBAction private func searchFieldEditingEnded(_ sender: Any) {
        if searchField.text!.isEmpty {
            viewState = .displaySaved
            tableView.reloadData()
            notFoundLabel.isHidden = true
        } else{
            viewState = .filtered
            if bookmarkedPosts.filter({$0.title.contains(searchField.text ?? "")}).count == 0{
                notFoundLabel.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    @IBAction private func openSavedPostsButton(_ sender: Any) {
        savedPostViewEnabled.toggle()
        
        if savedPostViewEnabled {
            bookmarkedPosts = SaveService.loadPostsFromDocuments(from: saveLocation)
            searchField.isHidden = false
            searchField.text = ""
            viewState = .displaySaved
        } else {
            searchField.isHidden = true
            viewState = .normal
            notFoundLabel.isHidden = true
        }
        
        bookmarkButton.setImage(UIImage(systemName: savedPostViewEnabled ? "bookmark.circle.fill" : "bookmark.circle"), for: .normal)
        self.tableView.reloadData()
    }
    
    @IBAction private func didTapOnSearchField(_ sender: Any) {
        searchField.becomeFirstResponder()
    }

    //MARK: -
    var savedPostViewEnabled = false
    var postList: [Post] = []
    var bookmarkedPosts: [Post] = []
    var viewState: PostListViewState = .normal
    var lastLoadedPost: String?
    var selectedPost: Post?
    var selectedCell: PostTableViewCell?
    let domain = "ios"
    let postAmount = 10
    var isLoading = false
    let saveLocation = "posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        domainName.title = "r/" + domain
        bookmarkedPosts = SaveService.loadPostsFromDocuments(from: saveLocation)

        Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            do {
                let posts = try await ApiUtils.fetchPosts(self.domain, limit: self.postAmount)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.postList = posts.0
                    self.lastLoadedPost = posts.1
                    
                    self.markSavedPosts()
                    
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching posts: \(error)")
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
        
        tableView.register(PostTableViewCellSwiftUI.self, forCellReuseIdentifier: "SwiftUICell")
    }
    
    @objc
    func dismissKeyboard(){
        view.endEditing(true)
        searchField.endEditing(true)
    }
    
    //MARK: - Table view overrides
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewState {
            case .normal:
                return postList.count
            case .displaySaved:
                return bookmarkedPosts.count
            case .filtered:
                return bookmarkedPosts.filter({$0.title.contains(searchField.text ?? "")}).count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostTableViewCell
        
        let neededPostList: [Post]
        
        switch viewState{
            case .normal:
                neededPostList = postList
            case .displaySaved:
                neededPostList = bookmarkedPosts
            case .filtered:
                neededPostList = bookmarkedPosts.filter({$0.title.contains(searchField.text ?? "")})
        }
        
        if neededPostList[indexPath.row].isLocal {
            cell = tableView.dequeueReusableCell(withIdentifier: "SwiftUICell", for: indexPath) as! PostTableViewCellSwiftUI
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCellUIKit
        }
        cell.config(with: neededPostList[indexPath.row], self)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "go_to_post":
            let nextVC = segue.destination as! PostDetailsViewController
//            DispatchQueue.main.async{ [weak self] in
//                guard let self else { return }
                nextVC.config(self.selectedPost ?? Post(), parentCell: self.selectedCell)
//            }
        default:
            print("Unknown segue")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewState{
        case .normal:
            self.selectedPost = self.postList[indexPath.row]
            self.selectedCell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        case .displaySaved:
            self.selectedPost = self.bookmarkedPosts[indexPath.row]
            self.selectedCell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        case .filtered:
            self.selectedPost = self.bookmarkedPosts.filter({$0.title.contains(searchField.text ?? "")})[indexPath.row]
            self.selectedCell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewState{
            case .normal:
                return getHeightForPost(postList[indexPath.row])
            case .displaySaved:
                return getHeightForPost(bookmarkedPosts[indexPath.row])
            case .filtered:
                return getHeightForPost(bookmarkedPosts.filter({$0.title.contains(searchField.text ?? "")})[indexPath.row])
            }
    }
    
    //TODO: This shouldn't be here
    func getHeightForPost(_ post: Post) -> Double {
        if post.imagePath != nil {
            return 250
        }
        
        if post.imageURL == nil && post.imagePath == nil {
            return 145
        } else{
            if let height = post.imageHeight{
                return 115 + CGFloat(height > 170 ? 170 : height)
            }
            else{
                return 145
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewState != .normal{
            return
        }
        if isLoading { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        let threshold: CGFloat = 200.0
        
        if offsetY > contentHeight - screenHeight - threshold {
            loadMorePosts()
        }
    }
    
    //MARK: - Buttons and gestures
    private func loadMorePosts() {
        isLoading = true
        
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            do {
                let posts = try await ApiUtils.fetchPosts(self.domain, limit: self.postAmount, after: self.lastLoadedPost)
                
                guard !posts.0.isEmpty else {
                    isLoading = false
                    return
                }
                
                postList.append(contentsOf: posts.0)
                lastLoadedPost = posts.1
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                    self?.isLoading = false
                }
            } catch {
                print("Error fetching posts: \(error)")
                isLoading = false
            }
        }
    }
    
    func bookmarkPost(in cell: PostTableViewCell){
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let selectedPost = viewState == .displaySaved ? bookmarkedPosts[indexPath.row] : postList[indexPath.row]

        if selectedPost.saved {
            bookmarkedPosts.removeAll { $0.id == selectedPost.id }
            if let index = postList.firstIndex(where: { $0.id == selectedPost.id }) {
                postList[index].saved = false
            }
        } else {
            if !bookmarkedPosts.contains(where: { $0.id == selectedPost.id }) {
                bookmarkedPosts.append(selectedPost)
            }
            
            if let index = postList.firstIndex(where: { $0.id == selectedPost.id }) {
                postList[index].saved = true
            }
            
            if let index = bookmarkedPosts.firstIndex(where: { $0.id == selectedPost.id }) {
                bookmarkedPosts[index].saved = true
            }
        }
        
        SaveService.setPostsInDocumentsDirectory(bookmarkedPosts, at: saveLocation)
    }
    
    func markSavedPosts(){
        for p in 0..<postList.count{
            if bookmarkedPosts.contains(where: {$0.id == postList[p].id}){
                postList[p].saved = true
            }
        }
    }
    
    func reloadTable(){
        tableView.reloadData()
    }
}

extension PostListViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFieldEditingEnded(textField)
        
        textField.resignFirstResponder()
        
        return true
    }
}
