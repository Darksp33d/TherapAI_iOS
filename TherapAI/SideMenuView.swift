import SwiftUI

struct SideMenuView: View {
    var closeAction: () -> Void
    @Binding var navigateToAboutMe: Bool
    @Binding var navigateToJournalMain: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ForEach(["Chat", "About Me", "Journal"], id: \.self) { label in
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                        switch label {
                            case "Chat": closeAction()
                            case "About Me":
                                navigateToAboutMe = true
                                closeAction()
                            case "Journal":
                                navigateToJournalMain = true
                                closeAction()
                            default: break
                        }
                    }
                }) {
                    Text(label)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                        .foregroundColor(Color.accentColor.opacity(0.8))
                }
            }
            Spacer()
        }
        .padding(.top, 50)
        .padding([.leading, .trailing], 25)
        .frame(width: UIScreen.main.bounds.width * 0.55)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: -5, y: 0)
    }
}
