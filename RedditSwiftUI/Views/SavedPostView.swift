//
//  PostView.swift
//  RedditSwiftUI
//
//  Created by Володимир on 27.04.2025.
//

import SwiftUI

struct SavedPostView: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 5){
                Text(post.author)
                Text("•")
                Text(post.date)
                Text("•")
                Text(post.domain)
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
        .background(.orange.opacity(0.5))
    }
}

#Preview {
    SavedPostView(post: Post(userPost: UserPost(title: "Title", description: "test", imagePath: nil, author: "Author", date: "555", domain: "Test")))
}
