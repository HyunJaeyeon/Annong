import SwiftUI
import SwiftData

struct MessageBoxView: View {
    
    @State var isShownFullScreenCover = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("💎kanto00의 우편함")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.accent)
                .padding(.leading)
            
            List {
                Text("나 스티브잡스인데, 이 앱 좋다")
                Text("나 조너선 아이브인데, 이 앱 이쁘다")
            }
        }
        
        Button(action: {
            self.isShownFullScreenCover.toggle()
        }, label: {
            Text("쪽지 작성하기")
                .foregroundStyle(.accent)
                .padding()
                .padding(.horizontal, 8)
                .background(.accent.opacity(0.15))
        })
        .clipShape(Capsule())
        .fullScreenCover(isPresented: $isShownFullScreenCover) {
            WritingView()
        }
    }
}

#Preview {
    MessageBoxView()
        .preferredColorScheme(.dark)
}
