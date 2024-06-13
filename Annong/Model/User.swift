import Foundation
import SwiftData

@Model
class User {

    @Attribute(.unique) var nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
    }
}
