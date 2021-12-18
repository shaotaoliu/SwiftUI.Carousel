import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PostView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Posts")
                }
            
            CardView()
                .tabItem {
                    Image(systemName: "simcard.2")
                    Text("Cards")
                }
        }
    }
}

struct PostView: View {
    var body: some View {
        SnapCarousel(items: ViewModel().posts) { post in
            Image(post.postImage)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 450)
                .cornerRadius(20)
        }
        .frame(width: 300, height: 480)
    }
}

struct CardView: View {
    var body: some View {
        SnapCarousel(items: ViewModel().cards) { card in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                                .fill(card.color)
                                .frame(width: 300, height: 450)
                
                Text(card.text)
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
        }
        .frame(width: 300, height: 480)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
