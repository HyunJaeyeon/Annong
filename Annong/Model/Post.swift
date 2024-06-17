import Foundation
import SwiftData
import SwiftUI

@Model
class Post{
    
    @Attribute(.unique) var id = UUID()
    var title: String
    @Attribute(.externalStorage) var image: Data?
    var content: String
    var date: Date
    
    init(title: String, image: Data, content: String, date: Date) {
        self.title = title
        self.image = image
        self.content = content
        self.date = date
    }
}
