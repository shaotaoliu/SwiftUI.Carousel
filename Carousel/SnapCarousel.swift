import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var list: [T]
    var content: (T) -> Content
    
    init(items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.content = content
    }
    
    @State var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    ForEach(list) { item in
                        content(item)
                    }
                }
                .offset(x: -proxy.size.width * CGFloat(currentIndex) + offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation {
                                if -value.translation.width > proxy.size.width / 2 && currentIndex < list.count - 1 {
                                    currentIndex += 1
                                }
                                else if value.translation.width > proxy.size.width / 2 && currentIndex > 0 {
                                    currentIndex -= 1
                                }
                                
                                offset = 0
                            }
                        }
                )
            }
            .clipped()
            
            HStack(spacing: 8) {
                ForEach(list.indices, id: \.self) { i in
                    Circle()
                        .fill(Color.black.opacity(currentIndex == i ? 1.0 : 0.1))
                        .frame(width: 6, height: 6)
                        .scaleEffect(currentIndex == i ? 1.3 : 1.0)
                        .animation(.spring(), value: currentIndex == i)
                }
            }
        }
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
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
