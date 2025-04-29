import Foundation
import SwiftUI

class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    @ViewBuilder
    func makePostRow(_ post: Post) -> some View {
        
    }
    
    @ViewBuilder
    func loadImage(post: UserPost) -> some View {
        if let imagePath = post.imagePath,
           let uiImage = UIImage(contentsOfFile: imagePath) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        }
    }
    
    func refreshPosts() {
        self.posts = PostService.loadPosts(from: PostService.getPathInDocumentsDirectory(withFileName: "posts"))
    }
}
