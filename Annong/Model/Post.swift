import Foundation
import SwiftData

@Model
class Post{
    
    @Attribute(.unique) var id = UUID()
    var title: String
    @Attribute(.externalStorage) var image: Data
    var context: String
    
    init(title: String, image: Data, context: String) {
        self.title = title
        self.image = image
        self.context = context
    }
}
