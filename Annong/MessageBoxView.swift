import SwiftUI
import SwiftData

struct MessageBoxView: View {
    
    @Binding var myNickname: String
    @State private var isShownFullScreenCover = false
    
    @Query private var posts: [Post]
      
    var body: some View {
    
        VStack(alignment: .leading, spacing: 0) {
            Text("💎 \(myNickname)의 우편함")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.leading)
            
            List {
                ForEach(posts.sorted(by: { $0.date > $1.date })) { post in
                    NavigationLink(destination: MessageView(post: post)) {
                        Text(post.title)
                    }
                }
            }
        }
        .padding(.top)
        
        Button(action: {
            self.isShownFullScreenCover.toggle()
        }, label: {
            Text("쪽지 작성하기")
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding()
                .padding(.horizontal, 8)
        })
        .background(.accent)
        .clipShape(.capsule)
        .fullScreenCover(isPresented: $isShownFullScreenCover) {
            WritingView(isShownFullScreenCover: $isShownFullScreenCover)
        }
        .padding(.bottom)
    }
}
