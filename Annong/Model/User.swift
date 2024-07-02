import Foundation
import FirebaseFirestore
<<<<<<< HEAD
=======
import FirebaseFirestoreSwift
>>>>>>> origin/main

// 사용자(User) 모델 정의
struct User: Identifiable, Codable {
    var id: String? // Firestore 문서 ID
    var nickname: String // 사용자의 닉네임
    var uid: String // Firebase 인증 UID
    var receivedPosts: [DocumentReference] // 사용자가 받은 Post
}
