import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var user: User?
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PostListViewControllerSwiftUI()
                .tabItem{
                    Label("Feed", systemImage: "list.bullet")
                }
//            PostListView()
//                .tabItem {
//                    Label("Feed", systemImage: "list.bullet")
//                }
                .tag(0)
            
            CreatePostView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Create post", systemImage: "plus.square.on.square")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
