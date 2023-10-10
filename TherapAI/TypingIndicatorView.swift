import SwiftUI

struct TypingIndicatorView: View {
    @State private var scaleValues: [CGFloat] = [1, 1, 1]
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(Color.gray)
                    .scaleEffect(self.scaleValues[index])
                    .modifier(FadeInModifier(delay: 0.4))  // Apply the fade-in effect with a delay
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(index) * 0.2)) {
                            self.scaleValues[index] = 1.4
                        }
                    }
                    .onDisappear {
                        self.scaleValues[index] = 1
                    }
            }
        }
    }
}
