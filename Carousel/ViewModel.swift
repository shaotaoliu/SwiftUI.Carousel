import SwiftUI

class ViewModel: ObservableObject {
    var posts: [Post] = []
    var cards: [Card] = []
    
    init() {
        for index in 1...8 {
            posts.append(Post(postImage: "post\(index)"))
        }
        
        cards.append(Card(text: "Hello World", color: .red))
        cards.append(Card(text: "Good morning", color: .green))
        cards.append(Card(text: "How are you", color: .blue))
        cards.append(Card(text: "You are welcome", color: .orange))
        cards.append(Card(text: "Thank you", color: .purple))
        cards.append(Card(text: "See you later", color: .brown))
    }
}

struct Post: Identifiable {
    var id = UUID()
    var postImage: String
}

struct Card: Identifiable {
    var id = UUID()
    var text: String
    var color: Color
}
