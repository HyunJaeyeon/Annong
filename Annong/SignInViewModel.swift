//
//  SignInViewModel.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 7/2/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class SignInViewModel: ObservableObject {

    @Published var nonce = ""

    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        //getting token
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }

        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }

        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        Auth.auth().signIn(with: firebaseCredential) { result, err in
            if let err = err {
                print(err.localizedDescription)
            }

            guard let user = result?.user else { return }
            let userUID = user.uid

            // Firestore에 사용자 정보 저장
            let userData = User(id: nil, nickname: "", uid: userUID, receivedPosts: [])
            self.saveUserDataToFirestore(user: userData)

            print("로그인 완료!!!!!!!!!, user UID: \(userUID)")

        }
    }

    private func saveUserDataToFirestore(user: User) {
            let db = Firestore.firestore()

            do {
                try db.collection("Users").document(user.uid).setData(from: user) { error in
                    if let error = error {
                        print("Error writing user data to Firestore: \(error)")
                    } else {
                        print("User data successfully written to Firestore.")
                    }
                }
            } catch let error {
                print("Error encoding user data: \(error)")
            }
        }
}

// Helper for Apple Login with Firebase
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()

    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}
