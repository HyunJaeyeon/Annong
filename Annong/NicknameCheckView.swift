import SwiftUI
import FirebaseFirestore

struct NicknameCheckView: View {
    
    @State private var friendNickname = ""
    @State private var isNavigate = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var recipientUid: String?
    
    @Binding var isShownFullScreenCover: Bool
    @ObservedObject var firestoreManager: FireStoreManager
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("친구의 닉네임을 입력해주세요")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                TextField("이름을 입력해주세요", text: $friendNickname)
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
                    .frame(width: 361)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShownFullScreenCover.toggle()
                    }) {
                        Text("취소")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        checkNicknameExists()
                    }) {
                        Text("다음")
                    }
                }
            }
            .navigationDestination(isPresented: $isNavigate) {
                if let recipientUid = recipientUid {
                    WritingView(
                        recipientUid: recipientUid,
                        authorUid: "", // 여기서 사용할 현재 사용자 UID
                        firestoreManager: firestoreManager,
                        isShownFullScreenCover: $isShownFullScreenCover
                    )
                } else {
                    Text("유효하지 않은 사용자입니다.")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(errorMessage ?? "알 수 없는 오류가 발생했습니다."), dismissButton: .default(Text("확인")))
            }
        }
    }
    
    private func checkNicknameExists() {
        let db = Firestore.firestore()
        
        db.collection("Users").whereField("nickname", isEqualTo: friendNickname).getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "받는 사람 정보를 가져올 수 없음: \(error.localizedDescription)"
                self.showAlert = true
                return
            }
            
            if let document = snapshot?.documents.first {
                if let uid = document["uid"] as? String {
                    self.recipientUid = uid
                    self.isNavigate = true
                } else {
                    self.errorMessage = "해당 사용자의 UID를 찾을 수 없습니다."
                    self.showAlert = true
                }
            } else {
                self.errorMessage = "해당 닉네임을 가진 사용자를 찾을 수 없습니다."
                self.showAlert = true
            }
        }
    }
}
