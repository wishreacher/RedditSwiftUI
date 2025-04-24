//
//  RedditModel.swift
//  RedditSwiftUI
//
//  Created by Володимир on 10.04.2025.
//

import Foundation

struct User: Codable {
    let name: String
}

struct Post: Identifiable, Codable {
    let title: String
    let text: String
    let imagePath: String?
    let author: User
    
    var id: String{
        return title
    }
}

enum CreatePostAlert: Identifiable {
    case missingUsername
    case incompletePost

    var id: Int {
        hashValue
    }

    var message: String {
        switch self {
        case .missingUsername:
            return "You need to set username"
        case .incompletePost:
            return "Post must have title, description and image"
        }
    }
}
