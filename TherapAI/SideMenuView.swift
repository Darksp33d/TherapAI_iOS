import SwiftUI

struct SideMenuView: View {
    var closeAction: () -> Void
    @Binding var navigateToAboutMe: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button("Chat") {
                closeAction()
            }
            Button("About Me") {
                navigateToAboutMe = true
                closeAction()
            }
            Spacer()
        }
        .padding(.top, 100)  // Add some top padding to lower the position of the buttons
        .padding(.leading)
        .frame(width: UIScreen.main.bounds.width / 3)  // Set width to a fourth of the screen
        .background(Color.gray)  // Change to any color you prefer
        .edgesIgnoringSafeArea(.all)
    }
}

