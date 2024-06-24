import Foundation
import FirebaseFirestore

// 글(Post) 모델 정의
struct Post: Identifiable, Codable {
    var id: String? // Firestore 문서 ID
    var title: String // 글 제목
    var content: String // 글 내용
    var authorNickname: String // 글 작성자의 닉네임
    var authorUid: String // 글 작성자의 Firebase UID
    var recipientUid: String // 글을 받는 사람의 Firebase UID
    var date: Timestamp // 글 작성 날짜
}
