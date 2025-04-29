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
