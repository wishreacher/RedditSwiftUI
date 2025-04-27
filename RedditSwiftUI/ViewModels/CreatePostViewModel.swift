//
//  CreatePostViewModel.swift
//  RedditSwiftUI
//
//  Created by Володимир on 10.04.2025.
//

import Foundation
import SwiftUI
import PhotosUI

class CreatePostViewModel: ObservableObject {
    @Published var presentImageSearch: Bool = false
    @Published var imageToShow: UIImage?
    @Published var postTitle: String = ""
    @Published var postDescription: String = ""
    @Published var user: User? = nil
    @Published var selectedTab: Int = 0
    @Published var selectedPhotoItem: PhotosPickerItem? = nil
    @Published var activeAlert: CreatePostAlert? = nil
    
    func canPost() -> Bool {
        return !postTitle.isEmpty && !postDescription.isEmpty
    }
    
    func publishButtonAction(selectedTab: Binding<Int>) {
        if user == nil {
            activeAlert = .missingUsername
            return
        }

        if canPost() {
            Task {
                var postImage: UIImage? = nil
                var imagePath: String? = nil
                
                if let selectedPhotoItem = selectedPhotoItem {
                    if let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        postImage = uiImage
                    }
                    imagePath = PostService.saveImageToDocumentsDirectory(image: postImage!)
                }
                
                //PostService.saveUserPost(title: postTitle, text: postDescription, image: postImage)
                
                //TODO: maybe force unwrap is not a good idea. tho this shouldn't happen if user is empty.
                //also rewise hardcoded values
                
                let userPost = UserPost(title: postTitle, description: postDescription, imagePath: imagePath, author: user!.name, date: "1745766630", domain: "swiftui")
                
                PostService.savePost(Post(userPost: userPost), at: PostService.getPathInDocumentsDirectory(withFileName: "posts"))
                
                await MainActor.run {
                    self.postTitle = ""
                    self.postDescription = ""
                    self.imageToShow = nil
                    self.selectedPhotoItem = nil
                    selectedTab.wrappedValue = 0
                }
            }
        } else {
            activeAlert = .incompletePost
        }
    }
}
