//
//  SaveUtils.swift
//  Reddit
//
//  Created by Володимир on 25.03.2025.
//

import Foundation

//TODO: for now it doesn't consider previously saved files. need to come up with a way to combine them
func saveBookmarkedPosts(_ postList: [Post], at location: String) {
    var data: Data = Data()
    
    do{
        data = try JSONEncoder().encode(postList) //.filter{$0.saved}
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

func loadBookmarkedPosts(at location: String) -> [Post] {
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
