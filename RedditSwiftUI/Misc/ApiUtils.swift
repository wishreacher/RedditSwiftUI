//
//  ApiUtils.swift
//  Reddit
//
//  Created by Володимир on 17.03.2025.
//

import Foundation

enum RedditError: Error{
    case receivedEmptyArray
    case decodingError
    case urlError
    case requestError
}

class ApiUtils{
    static func fetchPosts(_ subreddit: String, limit: Int, after: String? = nil) async throws -> ([Post], String?) {
        var urlString = "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)"
        if let after = after {
            urlString += "&after=\(after)"
        }

        guard let url = URL(string: urlString) else {
            throw RedditError.urlError
        }

        let data: (Data, URLResponse)
        do{
            data = try await URLSession.shared.data(for: URLRequest(url: url))
        }
        catch{
            throw RedditError.requestError
        }
        
        let response: RedditResponse
        do{
            response = try JSONDecoder().decode(RedditResponse.self, from: data.0)
        }
        catch{
            throw RedditError.decodingError
        }
        
        var postList: [Post] = []
    
        for child in response.data.children{
            postList.append(Post(redditPost: child.data))
        }
        
        guard let lastPost = postList.last else{
            throw RedditError.receivedEmptyArray
        }
        
        return (postList, "t3_\(lastPost.id)")
    }
}
    
