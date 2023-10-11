import SwiftUI

struct SideMenuView: View {
    var closeAction: () -> Void
    @Binding var navigateToAboutMe: Bool
    @Binding var navigateToMoodTracker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            ForEach(["Chat", "About Me", "Mood Tracker"], id: \.self) { label in
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                        switch label {
                        case "Chat":
                            closeAction()
                        case "About Me":
                            navigateToAboutMe = true
                            closeAction()
                        case "Mood Tracker":
                            navigateToMoodTracker = true
                            closeAction()
                        default:
                            break
                        }
                    }
                }) {
                    Text(label)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 50))
                        .background(Color.accentColor.opacity(0.2))
                        .foregroundColor(Color.accentColor)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 8)
                }
            }
            Spacer()
        }
        .padding(.top, 20) // Reduced top padding
        .padding([.leading, .trailing], 20)  // Horizontal padding to the VStack
        .frame(width: UIScreen.main.bounds.width * 0.6)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 0)
    }
}

