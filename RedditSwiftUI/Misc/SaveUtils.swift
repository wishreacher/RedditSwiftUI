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
    
    static func savePost(_ post: Post, at location: String) {
        var posts: [Post] = []
        
        //pull existing posts if they exist
        if FileManager.default.fileExists(atPath: location) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: location))
                posts = try JSONDecoder().decode([Post].self, from: data)
            } catch {
                print("Failed to load existing posts from file: \(error)")
            }
        }

        posts.append(post)
        
        do {
            let encodedData = try JSONEncoder().encode(posts)
            
            if FileManager.default.fileExists(atPath: location) {
                try FileManager.default.removeItem(atPath: location)
            }
            FileManager.default.createFile(atPath: location, contents: encodedData)
            
        } catch {
            print("Failed to encode and save posts: \(error)")
        }
    }
    
    static func setSavedPosts(_ posts: [Post], at location: String) {
        do {
            let encodedData = try JSONEncoder().encode(posts)
            
            if FileManager.default.fileExists(atPath: location) {
                try FileManager.default.removeItem(atPath: location)
            }
            
            FileManager.default.createFile(atPath: location, contents: encodedData)
            
        } catch {
            print("Failed to encode and save posts: \(error)")
        }
    }
    
    static func loadPosts(from location: String) -> [Post] {
        if FileManager.default.fileExists(atPath: location) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: location))
                let posts = try JSONDecoder().decode([Post].self, from: data)
                return posts
            } catch {
                print("Failed to load or decode posts: \(error)")
            }
        }
        print("No posts found at \(location)")
        return []
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

    static func loadImageFromPath(_ path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        return UIImage(contentsOfFile: url.path)
    }
    
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func getPathInDocumentsDirectory(withFileName fileName: String) -> String {
        return getDocumentsDirectory().appendingPathComponent(fileName).path()
    }

//    static func saveUserPost(title: String, text: String, image: UIImage?) {
//        guard let user = loadUser() else { return }
//        
//        let post: UserPost
//        
//        if image == nil {
//            post = UserPost(title: title, text: text, imagePath: nil, author: user)
//        } else{
//            let imageName = saveImageToDocumentsDirectory(image: image!)
//            post = UserPost(title: title, text: text, imagePath: imageName, author: user)
//        }
//
//        var savedPosts: [UserPost] = []
//        if let savedData = UserDefaults.standard.data(forKey: "savedPosts"),
//           let decodedPosts = try? JSONDecoder().decode([UserPost].self, from: savedData) {
//            savedPosts = decodedPosts
//        }
//
//        savedPosts.append(post)
//
//        if let encoded = try? JSONEncoder().encode(savedPosts) {
//            UserDefaults.standard.set(encoded, forKey: "savedPosts")
//        }
//    }
    
//    static func loadSavedUserPosts() -> [UserPost] {
//        if let savedData = UserDefaults.standard.data(forKey: "savedPosts") {
//            if let decodedPosts = try? JSONDecoder().decode([UserPost].self, from: savedData) {
//                return decodedPosts
//            }
//        }
//        
//        return []
//    }
    
//    static func saveBookmarkedPosts(_ postList: [Post], at location: String) {
//        var data: Data = Data()
//        
//        do{
//            data = try JSONEncoder().encode(postList)
//        }
//        catch{
//            print("Postlist encoding error")
//            return
//        }
//        
//        if FileManager.default.fileExists(atPath: location){
//            do{
//                try FileManager.default.removeItem(atPath: location)
//            }
//            catch{
//                print("File delition error")
//            }
//        }
//        
//        FileManager.default.createFile(atPath: location, contents: data)
//    }
//
//    static func loadBookmarkedPosts(at location: String) -> [Post] {
//        if FileManager.default.fileExists(atPath: location){
//            do{
//                let data: Data = try Data(contentsOf: URL(fileURLWithPath: location))
//                return try JSONDecoder().decode([Post].self, from: data)
//            }
//            catch{
//                print("File reading error")
//            }
//        }
//        return []
//    }

}
