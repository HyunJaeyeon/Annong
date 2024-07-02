import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


// Post 데이터 저장 프로토콜 정의
protocol PostDataStore {
    func fetchPosts()
    func addPost(_ post: Post, recipientUid: String, completion: @escaping (Bool) -> Void)
    func removePost(_ post: Post)
}

// User 데이터 저장 프로토콜 정의
protocol UserDataStore {
    func fetchUsers()
    func addUser(_ user: User)
    func addPostReferenceToUser(userId: String, postRef: DocumentReference)
}

// FireStoreManager 정의
class FireStoreManager: ObservableObject {
    @Published var users: [User] = []
    @Published var posts: [Post] = []
    let database = Firestore.firestore()
    
    func fetchReceivedPosts(forUserUid uid: String) {
        // 현재 게시물 목록 초기화
        self.posts.removeAll()
        
        // 사용자의 receivedPosts 참조를 가져옴
        database.collection("Users").whereField("uid", isEqualTo: uid).addSnapshotListener { snapshot, error in
            if let snapshot = snapshot, let userDoc = snapshot.documents.first {
                // 필드 추출 시 물음표와 띄어쓰기를 올바르게 수정
                let receivedPostsRefs = userDoc.data()["receivedPosts"] as? [String] ?? []
                // String 경로를 DocumentReference로 변환하여 사용
                let documentReferences = receivedPostsRefs.map { self.database.document($0) }
                self.fetchPostsByReferences(documentReferences)
            } else {
                print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    
    // 문서 참조 경로로 게시물을 가져오는 함수
    private func fetchPostsByReferences(_ references: [DocumentReference]) {
        // 기존 데이터 삭제
        self.posts.removeAll()
        
        let dispatchGroup = DispatchGroup()
        
        for ref in references {
            dispatchGroup.enter()
            ref.addSnapshotListener { document, error in
                if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let content = data["content"] as? String ?? ""
                    let authorUid = data["authorUid"] as? String ?? ""
                    let recipientUid = data["recipientUid"] as? String ?? ""
                    let timestamp = data["date"] as? Timestamp ?? Timestamp()
                    
                    let post = Post(id: id, title: title, content: content, authorUid: authorUid, recipientUid: recipientUid, date: timestamp.dateValue())
                    
                    DispatchQueue.main.async {
                        // 기존 게시물에 동일한 ID가 있는 경우 교체
                        if let index = self.posts.firstIndex(where: { $0.id == id }) {
                            self.posts[index] = post
                        } else {
                            self.posts.append(post)
                        }
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All posts fetched")
        }
    }
}

// FireStoreManager의 User 관련 기능 구현
extension FireStoreManager: UserDataStore {
    func fetchUsers() {
        database.collection("Users").getDocuments { snapshot, error in
            self.users.removeAll()
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let id = document.documentID
                    let docData = document.data()
                    let nickname = docData["nickname"] as? String ?? ""
                    let uid = docData["uid"] as? String ?? ""
                    let receivedPostsRefs = docData["receivedPosts"] as? [DocumentReference] ?? []
                    
                    let user = User(id: id, nickname: nickname, uid: uid, receivedPosts: receivedPostsRefs)
                    self.users.append(user)
                }
            } else if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    func addUser(_ user: User) {
        let documentId = user.id ?? UUID().uuidString
        let userRef = database.collection("Users").document(documentId)
        userRef.setData([
            "nickname": user.nickname,
            "uid": user.uid,
            "receivedPosts": user.receivedPosts
        ]) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
            } else {
                print("User successfully added!")
            }
        }
    }
    
    func addPostReferenceToUser(userId: String, postRef: DocumentReference) {
        let userRef = database.collection("Users").document(userId)
        userRef.updateData([
            "receivedPosts": FieldValue.arrayUnion([postRef])
        ]) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
            } else {
                print("User's receivedPosts updated!")
            }
        }
    }
}

// FireStoreManager의 Post 관련 기능 구현
extension FireStoreManager: PostDataStore {
    func fetchPosts() {
        database.collection("Posts").getDocuments { snapshot, error in
            self.posts.removeAll()
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let id = document.documentID
                    let docData = document.data()
                    let title = docData["title"] as? String ?? ""
                    let content = docData["content"] as? String ?? ""
                    let authorUid = docData["authorUid"] as? String ?? ""
                    let recipientUid = docData["recipientUid"] as? String ?? ""
                    let timestamp = docData["date"] as? Timestamp ?? Timestamp()
                    
                    let post = Post(id: id, title: title, content: content, authorUid: authorUid, recipientUid: recipientUid, date: timestamp.dateValue())
                    self.posts.append(post)
                }
            } else if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }
    }
    
    func addPost(_ post: Post, recipientUid: String, completion: @escaping (Bool) -> Void) {
        let postRef = database.collection("Posts").document()
        
        postRef.setData([
            "title": post.title,
            "content": post.content,
            "authorUid": post.authorUid,
            "recipientUid": post.recipientUid,
            "date": Timestamp(date: post.date)
        ]) { error in
            if let error = error {
                print("Error adding post: \(error.localizedDescription)")
                completion(false)
            } else {
                self.updateUserReceivedPosts(userUid: recipientUid, postRef: postRef, completion: completion)
            }
        }
    }
    
    private func updateUserReceivedPosts(userUid: String, postRef: DocumentReference, completion: @escaping (Bool) -> Void) {
        database.collection("Users").whereField("uid", isEqualTo: userUid).getDocuments { snapshot, error in
            if let error = error {
                print("Error querying user documents: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let snapshot = snapshot else {
                print("No documents found for user UID: \(userUid)")
                completion(false)
                return
            }
            
            if let userDoc = snapshot.documents.first {
                let userRef = self.database.collection("Users").document(userDoc.documentID)
                userRef.updateData([
                    "receivedPosts": FieldValue.arrayUnion([postRef.path])
                ]) { error in
                    if let error = error {
                        print("Error updating receivedPosts: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("User's receivedPosts updated successfully!")
                        completion(true)
                    }
                }
            } else {
                print("No user document found for UID: \(userUid)")
                completion(false)
            }
        }
    }
    
    
    func removePost(_ post: Post) {
        guard let postId = post.id else { return }
        database.collection("Posts").document(postId).delete { error in
            if let error = error {
                print("Error removing post: \(error.localizedDescription)")
            } else {
                print("Post successfully removed!")
                self.fetchPosts()
            }
        }
    }
}

