import SwiftUI

struct SavedPostView: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 5){
                Text(post.author)
                Text("•")
                Text(post.date)
                Text("•")
                Text(post.domain)
                Spacer()
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.blue)
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            Text(post.title)
                .font(.title)
            
            HStack{
                Spacer()
                if let imagePath = post.imagePath, let image = SaveService.loadImageFromPath(SaveService.getPathInDocumentsDirectory(withFileName: imagePath)) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                        }
                Spacer()
            }
            
            HStack (spacing: 15) {
                HStack (spacing: 3) {
                    Image(systemName: "arrowshape.up")
                    Text("456")
                }
                
                HStack (spacing: 3) {
                    Image(systemName: "message")
                    Text("123")
                }
                
                Spacer()
            }
        }
        .padding(15)
        .background(.orange.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}

#Preview {
    SavedPostView(post: Post(userPost: UserPost(title: "Title", description: "test", imagePath: nil, author: "Author", date: "555", domain: "Test")))
}
