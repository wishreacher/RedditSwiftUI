//
//  PostModel.swift
//  Reddit
//
//  Created by Володимир on 10.03.2025.
//

import Foundation

struct RedditResponse: Codable {
    let data: RedditData
}

struct RedditData: Codable {
    let children: [RedditChild]
    let after: String?
}

struct RedditChild: Codable {
    let data: RedditPost
}

struct RedditPost: Codable {
    let id: String
    let title: String
    let author: String
    let created: Double
    let ups: Int
    let downs: Int
    let num_comments: Int
    let url: String
    let selftext: String?
    let thumbnail: String?
    let preview: Preview?
    let domain: String
    let saved: Bool
    let author_fullname: String
}

struct Preview: Codable {
    let images: [Image]
    
    struct Image: Codable {
        let source: Source
        struct Source: Codable {
            let url: String
            let height: Int
        }
    }
}

//needs to be codable for saving
struct Post: Codable {
    let id: String
    let title: String
    let author: String
    let date: String
    let upvotes: Int
    let downvotes: Int
    let commentCount: Int
    let url: URL
    let description: String?
    let imageURL: URL?
    let domain: String
    var saved: Bool
    let authorID: String
    let imageHeight: Int?
    
    init(from redditPost: RedditPost) {
        self.id = redditPost.id
        self.title = redditPost.title
        self.author = redditPost.author
        self.saved = redditPost.saved
        self.authorID = redditPost.author_fullname
        self.imageHeight = redditPost.preview?.images.first?.source.height
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .day, .hour, .minute], from: Date(timeIntervalSince1970: redditPost.created), to: Date.now)
        var formattedString = ""

        if let years = components.year, years > 0 {
            formattedString += "\(years) year\(years > 1 ? "s" : "")"
        }
        if let days = components.day, days > 0 {
            formattedString += "\(days) day\(days > 1 ? "s" : "") "
        }
        if let hours = components.hour, hours > 0 {
            formattedString += "\(hours) hour\(hours > 1 ? "s" : "") "
        }
        formattedString += " ago"
        if formattedString.isEmpty {
            if let minutes = components.minute, minutes > 0{
                formattedString += "\(minutes) minute\(minutes > 1 ? "s" : "")"
            } else {
                formattedString = "less than a minute"
            }
        }
        self.date = formattedString.trimmingCharacters(in: .whitespaces)
        
        
        self.upvotes = redditPost.ups
        self.downvotes = redditPost.downs
        self.commentCount = redditPost.num_comments
        self.url = URL(string: redditPost.url)!
        self.description = redditPost.selftext
        self.domain = redditPost.domain
        
        //AI generated
        if let preview = redditPost.preview,
           let firstImage = preview.images.first,
           let imageURL = URL(string: firstImage.source.url.replacingOccurrences(of: "&amp;", with: "&")) {
            // The preview image is usually the best quality
            self.imageURL = imageURL
        } else if let thumbnail = redditPost.thumbnail,
                  thumbnail != "self" && thumbnail != "default",
                  let thumbnailURL = URL(string: thumbnail) {
            // Fallback to thumbnail
            self.imageURL = thumbnailURL
        } else if redditPost.url.hasSuffix(".jpg") ||
                  redditPost.url.hasSuffix(".png") ||
                  redditPost.url.hasSuffix(".gif"),
                  let directURL = URL(string: redditPost.url) {
            // Last resort: direct image URL
            self.imageURL = directURL
        } else {
            self.imageURL = nil
        }
    }
    
    init(){
        id = ""
        title = ""
        author = ""
        date = ""
        upvotes = 0
        downvotes = 0
        commentCount = 0
        url = URL("")!
        description = ""
        imageURL = nil
        domain = ""
        saved = false
        authorID = ""
        imageHeight = 0
    }
}
