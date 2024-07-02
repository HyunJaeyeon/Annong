//
//  SignInView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 7/2/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices

struct SignInView: View {
    
    @State private var userName = ""
    @State private var errorMessage: String?
    @StateObject private var loginData = SignInViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("안농하세요?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
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
                            window.rootViewController = UIHostingController(rootView: OnboardingView().preferredColorScheme(.dark))
                            window.makeKeyAndVisible()
                        }
                    }
                }
            case .revoked:
                print("revoked")
            case .notFound:
                print("notFound")
            default:
                break
            }
        }
    }
}

#Preview {
    SignInView()
        .preferredColorScheme(.dark)
}
