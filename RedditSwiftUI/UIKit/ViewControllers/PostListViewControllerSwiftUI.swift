//
//  PostListViewControllerSwiftUI.swift
//  RedditSwiftUI
//
//  Created by Володимир on 24.04.2025.
//

import Foundation
import SwiftUI

struct PostListViewControllerSwiftUI: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> PostListViewController {
        UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //we don't need anything here
    }
}
