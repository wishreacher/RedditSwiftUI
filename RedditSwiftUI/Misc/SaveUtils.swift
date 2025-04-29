import Foundation
import SwiftUI

struct SaveService {
    static func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "savedUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    static func loadPostsFromDocuments(from location: String) -> [Post] {
        loadPosts(from: getPathInDocumentsDirectory(withFileName: location))
    }
    
    static func savePostToDocumentsDirectory(_ post: Post, at location: String) {
        savePost(post, at: getPathInDocumentsDirectory(withFileName: location))
    }
    
    static func setPostsInDocumentsDirectory(_ posts: [Post], at location: String) {
        setSavedPosts(posts, at: getPathInDocumentsDirectory(withFileName: location))
    }
    
    static func deletePostFromDocumentsDirectory(_ post: Post, from location: String) {
        var posts: [Post] = []
        let path = getPathInDocumentsDirectory(withFileName: location)
        
        posts = loadPosts(from: path)
        
        if posts.contains(post) {
            if let index = posts.firstIndex(of: post) {
                posts.remove(at: index)
            }
        }
        
        setSavedPosts(posts, at: path)
    }
    
    private static func savePost(_ post: Post, at location: String) {
        var posts: [Post] = []
        
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
    
    private static func setSavedPosts(_ posts: [Post], at location: String) {
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
    
    private static func loadPosts(from location: String) -> [Post] {
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
    
    static func loadImageFromPath(_ path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        return UIImage(contentsOfFile: url.path)
    }
    
    static func getPathInDocumentsDirectory(withFileName fileName: String) -> String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName).path()
    }
}
