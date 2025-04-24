import Foundation
import SwiftUI

struct PostService {
    static func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "savedUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }

    static func saveImageToDocumentsDirectory(image: UIImage) -> String? {
        let imageName = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsDirectory.appendingPathComponent(imageName)

        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }

        do {
            try imageData.write(to: imagePath)
            return imageName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }

    static func getImagePath(for filename: String) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsDirectory.appendingPathComponent(filename)
        return imagePath.path
    }

    static func loadImageFromPath(_ imageName: String) -> UIImage? {
        let fullPath = getImagePath(for: imageName)
        return UIImage(contentsOfFile: fullPath)
    }

    static func saveUserPost(title: String, text: String, image: UIImage?) {
        guard let user = loadUser() else { return }
        
        let post: UserPost
        
        if image == nil {
            post = UserPost(title: title, text: text, imagePath: nil, author: user)
        } else{
            let imageName = saveImageToDocumentsDirectory(image: image!)
            post = UserPost(title: title, text: text, imagePath: imageName, author: user)
        }

        var savedPosts: [UserPost] = []
        if let savedData = UserDefaults.standard.data(forKey: "savedPosts"),
           let decodedPosts = try? JSONDecoder().decode([UserPost].self, from: savedData) {
            savedPosts = decodedPosts
        }

        savedPosts.append(post)

        if let encoded = try? JSONEncoder().encode(savedPosts) {
            UserDefaults.standard.set(encoded, forKey: "savedPosts")
        }
    }
    
    static func loadSavedUserPosts() -> [UserPost] {
        if let savedData = UserDefaults.standard.data(forKey: "savedPosts") {
            if let decodedPosts = try? JSONDecoder().decode([UserPost].self, from: savedData) {
                return decodedPosts
            }
        }
        
        return []
    }
    
    static func saveBookmarkedPosts(_ postList: [Post], at location: String) {
        var data: Data = Data()
        
        do{
            data = try JSONEncoder().encode(postList)
        }
        catch{
            print("Postlist encoding error")
            return
        }
        
        if FileManager.default.fileExists(atPath: location){
            do{
                try FileManager.default.removeItem(atPath: location)
            }
            catch{
                print("File delition error")
            }
        }
        
        FileManager.default.createFile(atPath: location, contents: data)
    }

    static func loadBookmarkedPosts(at location: String) -> [Post] {
        if FileManager.default.fileExists(atPath: location){
            do{
                let data: Data = try Data(contentsOf: URL(fileURLWithPath: location))
                return try JSONDecoder().decode([Post].self, from: data)
            }
            catch{
                print("File reading error")
            }
        }
        return []
    }
}
