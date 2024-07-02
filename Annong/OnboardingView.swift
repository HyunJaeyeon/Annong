//
//  OnboardingView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices
//import Combine

struct OnboardingView: View {
    
    @State private var userName = ""
    @State private var errorMessage: String?
    @StateObject private var loginData = LoginViewModel()
    
//    init() {
//        checkAppleIDCredentialState()
//    }
    @State var userID = ""
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
                
//                TextField("이름을 입력해주세요", text: $nickname)
//                    .padding()
//                    .background(Color.secondary.opacity(0.15))
//                    .clipShape(Capsule())
//                    .frame(width: 361)
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

//            NavigationLink(destination:
//                            MessageBoxView(firestoreManager: firestoreManager, myNickname: $nickname, myUid: $uid)
//                           
//                           
//                .navigationBarHidden(true),
//                           isActive: $isNavigate) {
//                EmptyView()
//            }
            
            //MARK: - SignWithApple
            SignInWithAppleButton(.signIn) { request in
                loginData.nonce = randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = sha256(loginData.nonce)
                
            } onCompletion: { result in
                switch result {
                case .success(let user):
                    print("success")
                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                        print("error with firebase")
                        return
                    }
                    loginData.authenticate(credential: credential)
                    
                    // Check the credential state after successful authentication
                    let userID = credential.user
                    print("\(credential.fullName!)")
                    if let fullName = credential.fullName {
                        userName = PersonNameComponentsFormatter().string(from: fullName)
                        print("내 이름은!!!!!!!!!!!\(userName)")
                    }
                    checkAppleIDCredentialState(userID: userID)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 45)
            .padding()
            
           
        }
        
        
    }
    
    private func checkAppleIDCredentialState(userID: String) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
        @State var isCover = true
        
            appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
                if let error = error {
                    print("Credential State request returned with error: \(error.localizedDescription)")
                    return
                }
                
                switch credentialState {
                case .authorized:
                    print("authorized")
                    // The Apple ID credential is valid.
                    DispatchQueue.main.async {
                        // authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                window.rootViewController = UIHostingController(rootView: MessageBoxView(firestoreManager: firestoreManager, myNickname: $userName, myUid: $userID).preferredColorScheme(.dark))
                                window.makeKeyAndVisible()
                            }
                        }
                    }
                case .revoked:
                    print("revoked")
                case .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    print("notFound")
                default:
                    break
                }
            }
        }
    
    private func saveUser() {
        // 고유 식별자 생성
       
        
        // Firestore의 DocumentReference 객체를 생성하지 않고 빈 배열로 초기화
        let newUser = User(id: nil, nickname: nickname, uid: userID, receivedPosts: [])
        
        // Firestore에 유저 추가
        firestoreManager.addUser(newUser)
        self.isNavigate = true
    }
//            .disabled(isNavigate) // 네비게이션 활성화 상태일 때 버튼 비활성화
}

    
    
    





//#Preview {
//    OnboardingView()
//        .preferredColorScheme(.dark)
//}
