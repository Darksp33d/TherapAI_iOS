import SwiftUI

extension AnyTransition {
    static var fadeAndMoveUp: AnyTransition {
        AnyTransition.opacity
            .combined(with: .move(edge: .top))
    }
}

struct SplashScreenView: View {
    var completion: () -> Void

    @State private var typedText = ""
    @State private var isTypingComplete = false
    @State private var shouldTransition = false // Control the transition

    var body: some View {
        ZStack {
            ContentView() // Display ContentView below the splash screen

            VStack {
                Text(typedText)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .onAppear {
                        animateText()
                    }

                if !isTypingComplete {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.white)
                        .opacity(shouldTransition ? 0 : 1)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: false))
                }
            }
        }
        .blur(radius: isTypingComplete ? 0 : 5.0) // Apply the blur effect
        .opacity(shouldTransition ? 0 : 1) // Initial opacity (starts visible)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                shouldTransition = true // Activate the transition after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    completion() // Trigger transition to ContentView after 1 second
                }
            }
        }
    }

    func animateText() {
        let fullText = "therapAI"
        let characters = Array(fullText)
        var currentIndex = 0 // Track the current character index
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentIndex < characters.count {
                typedText.append(characters[currentIndex])
                currentIndex += 1
            } else {
                timer.invalidate()
                isTypingComplete = true
            }
        }
    }
}
