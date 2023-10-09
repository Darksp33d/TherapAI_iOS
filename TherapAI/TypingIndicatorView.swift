import SwiftUI

struct TypingIndicatorView: View {
    @State private var shouldAnimate: Bool = false

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.gray)
                    .scaleEffect(self.shouldAnimate && index == 0 ? 1.5 : 1)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(index) * 0.2))
            }
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}
