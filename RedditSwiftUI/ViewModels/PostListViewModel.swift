//
//  PostListViewModel.swift
//  RedditSwiftUI
//
//  Created by Володимир on 13.04.2025.
//

import Foundation
import SwiftUI

class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    @ViewBuilder
    func makePostRow(_ post: Post) -> some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 5){
                Text(post.author.name)
                Text("•")
                Text("yesterday")
                Text("•")
                Text("domain")
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            Text(post.title)
                .font(.title)
            
            if let imagePath = post.imagePath, let image = PostService.loadImageFromPath(imagePath) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                    }
            
            HStack{
                Image(systemName: "arrowshape.up")
                Text("456")
                Spacer()
                Image(systemName: "message")
                Text("123")
                Spacer()
                Image(systemName: "square.and.arrow.up")
                Text("Share")
            }

        }
    }
    
    @ViewBuilder
    func loadImage(post: Post) -> some View {
        if let imagePath = post.imagePath,
           let uiImage = UIImage(contentsOfFile: imagePath) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        }
    }
    
    func refreshPosts() {
        self.posts = PostService.loadSavedPosts()
    }
}
