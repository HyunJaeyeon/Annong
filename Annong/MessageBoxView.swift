import SwiftUI
import SwiftData

struct MessageBoxView: View {
    
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
    }
}
#Preview {
    MessageBoxView()
        .preferredColorScheme(.dark)
}
