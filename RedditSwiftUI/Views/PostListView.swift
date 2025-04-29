import SwiftUI

struct PostListView: View {
    @StateObject var vm = PostListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(vm.posts, id: \.id) { post in
                    vm.makePostRow(post)
                        .frame(maxHeight: 300)
                }
            }
            .padding(16)
        }
        .onAppear{
            vm.refreshPosts()
        }
    }
}

#Preview {
    PostListView()
}
