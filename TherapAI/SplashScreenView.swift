import SwiftUI

struct SplashScreenView: View {
    var completion: () -> Void

    @State private var typedText = ""
    @State private var blurIntensity: CGFloat = 5.0
    @State private var textOpacity: Double = 1.0
    @State private var blurVisible: Bool = true

    var body: some View {
        ZStack {
            ContentView()
                .blur(radius: blurVisible ? blurIntensity : 0)

            Text(typedText)
                .font(.largeTitle)
                .foregroundColor(Color("accentColor"))
                .opacity(textOpacity)
                .onAppear {
                    animateText()
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    textOpacity = 0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        blurVisible = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        completion()
                    }
                }
            }
        }
    }

    func animateText() {
        let fullText = "therapAI"
        let characters = Array(fullText)
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentIndex < characters.count {
                typedText.append(characters[currentIndex])
                currentIndex += 1
            } else {
                timer.invalidate()

                // Begin fading text out of view after it finishes typing
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        textOpacity = 0
                    }
                }
            }
        }
    }
}
