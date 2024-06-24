import SwiftUI
import FirebaseFirestore

@Observable
class FireStoreManager {
    var users : [User] = []
    var posts : [Post] = []
     
    let database = Firestore.firestore()

}
