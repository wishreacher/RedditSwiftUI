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
            Task { @MainActor [weak self] in
                guard let self else {
                    print ("Self is nil")
                    return
                }
                
                var postImage: UIImage? = nil
                var imagePath: String? = nil
                
                if let selectedPhotoItem = selectedPhotoItem {
                    if let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        postImage = uiImage
                    }
                    imagePath = SaveService.saveImageToDocumentsDirectory(image: postImage!)
                }
            
                let userPost = UserPost(title: postTitle, description: postDescription, imagePath: imagePath, author: user!.name, date: "1745766630", domain: "swiftui")
                
                SaveService.savePostToDocumentsDirectory(Post(userPost: userPost), at: "posts")
                NotificationCenter.default.post(
                                name: Notification.Name("reloadTable"),
                                object: nil
                            )
                
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
