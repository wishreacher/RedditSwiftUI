import Foundation
import SwiftUI

struct PostListViewControllerSwiftUI: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        // Instantiate the PostListViewController from the storyboard
        let postListVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
        
        // Wrap the PostListViewController in a UINavigationController
        let navigationController = UINavigationController(rootViewController: postListVC)
        return navigationController
    }
    
    func updateUIViewController(_ uiNavigationController: UINavigationController, context: Context) {
        // No updates needed for now
    }
}
