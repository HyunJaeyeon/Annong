//
//  OnboardingView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//

import SwiftUI
import FirebaseFirestore

struct OnboardingView: View {
    @State var uid = UUID().uuidString
    @State var nickname = ""
    @State private var isNavigate = false
    @StateObject var firestoreManager = FireStoreManager()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("안농?\n닉네임을 입력해주세요")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                TextField("이름을 입력해주세요", text: $nickname)
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
                    .frame(width: 361)
            }
            
            Button(action: {
                saveUser()
            }) {
                Text("안농 시작하기")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .padding(.horizontal, 8)
            }
            .background(Color.accentColor)
            .clipShape(Capsule())
            .padding(.top, 80)
            .disabled(isNavigate) // 네비게이션 활성화 상태일 때 버튼 비활성화
            
            NavigationLink(destination:
                            MessageBoxView(firestoreManager: firestoreManager, myNickname: $nickname, myUid: $uid)
                           
                           
                .navigationBarHidden(true),
                           isActive: $isNavigate) {
                EmptyView()
            }
        }
    }
    
    
    
    private func saveUser() {
        // 고유 식별자 생성
       
        
        // Firestore의 DocumentReference 객체를 생성하지 않고 빈 배열로 초기화
        let newUser = User(id: nil, nickname: nickname, uid: uid, receivedPosts: [])
        
        // Firestore에 유저 추가
        firestoreManager.addUser(newUser)
        self.isNavigate = true
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
