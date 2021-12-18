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







struct SnapCarousel2<Content: View, T: Identifiable>: View {
    var list: [T]
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    var content: (T) -> Content
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }

    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: CGFloat(currentIndex) * -width + (currentIndex == 0 ? 0 : adjustMentWidth) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        
                        // Updating Current Index....
                        let offsetX = value.translation.width
                        
                        // were going to convert the tranlsation into progress (0 - 1)
                        // and round the value...
                        // based on the progress increasing or decreasing the currentIndex...
                        
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        // setting min...
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        // updating index....
                        currentIndex = index
                    })
                    .onChanged({ value in
                        // updating only index....
                        
                        // Updating Current Index....
                        let offsetX = value.translation.width
                        
                        // were going to convert the tranlsation into progress (0 - 1)
                        // and round the value...
                        // based on the progress increasing or decreasing the currentIndex...
                        
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        // setting min...
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        // Animatiing when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}
