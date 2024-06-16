import SwiftUI
import SwiftData

struct MessageBoxView: View {
    
    @Binding var myNickname: String
    @State private var isShownFullScreenCover = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("💎 \(myNickname)의 우편함")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.leading)
            
            List {
                Text("나 스티브잡스인데, 이 앱 좋다")
                Text("나 조너선 아이브인데, 이 앱 이쁘다")
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

#Preview {
    MessageBoxView(myNickname: .constant("젠예"))
        .preferredColorScheme(.dark)
}
