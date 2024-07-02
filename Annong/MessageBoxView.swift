import SwiftUI
import FirebaseFirestore

struct MessageBoxView: View {
    @ObservedObject var firestoreManager: FireStoreManager
    @Binding var myNickname: String
    @Binding var myUid: String  // Firebase UID for the current user
    @State private var isShownFullScreenCover = false
<<<<<<< HEAD

=======
    
>>>>>>> origin/main
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {
                Text("💎 \(myNickname)의 우편함")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.leading)
                
<<<<<<< HEAD
//                List {
//                    ForEach(posts.sorted(by: { $0.date > $1.date })) { post in
//                        NavigationLink(destination: MessageView(post: post)) {
//                            Text(post.title)
//                        }
//                    }
//                }
=======
                // Fetch posts on appear
                .onAppear {
                    firestoreManager.fetchReceivedPosts(forUserUid: myUid)
                }
                
                // List for displaying posts
                List {
                    ForEach(firestoreManager.posts.sorted(by: { $0.date > $1.date })) { post in
                        NavigationLink(destination: MessageView(post: post)) {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
                                Text(post.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
>>>>>>> origin/main
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
                NicknameCheckView(isShownFullScreenCover: $isShownFullScreenCover, firestoreManager: firestoreManager)
            }
            .padding(.bottom)
        }
    }
}

