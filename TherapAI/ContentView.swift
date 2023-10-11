import SwiftUI

enum Sender {
    case user
    case gpt
}

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var isWaitingForResponse: Bool = false
    @State private var isMenuVisible: Bool = false
    @State private var navigateToAboutMe: Bool = false
    @State private var navigateToMoodTracker: Bool = false

    
    let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.6  // Set it to 70% of the screen width

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                Color("background").edgesIgnoringSafeArea(.all)  // <-- Modern background color
                
                VStack {
                    ScrollView {
                        ScrollViewReader { proxy in
                            LazyVStack(spacing: 12) {
                                ForEach(chatMessages) { message in
                                    MessageView(message: message)
                                        .id(message.id)
                                }
                                if isWaitingForResponse {
                                    TypingIndicatorView()
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("bubbleBackground")))
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                }
                            }
                            .onChange(of: chatMessages) { _ in
                                if let lastMessage = chatMessages.last {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Enter your message...", text: $userInput)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bubbleBackground")))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .foregroundColor(Color("textColor"))
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("accentColor"))
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .offset(x: isMenuVisible ? menuWidth : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                
                if isMenuVisible {
                    SideMenuView(closeAction: {
                        withAnimation {
                            self.isMenuVisible = false
                        }
                    }, navigateToAboutMe: $navigateToAboutMe, navigateToMoodTracker: $navigateToMoodTracker)
                    .frame(width: menuWidth)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    withAnimation {
                        self.isMenuVisible.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .padding()
                        .foregroundColor(Color("iconColor"))
                }
            )
            .background(NavigationLink("", destination: AboutMeView(), isActive: $navigateToAboutMe))
            .background(NavigationLink("", destination: MoodTrackerView(), isActive: $navigateToMoodTracker))

        }
        .edgesIgnoringSafeArea(.all)  // This ensures the navigation view takes the entire screen width
        .accentColor(Color("accentColor"))
        }
    
    
    
    
    func sendMessage() {
        guard !userInput.isEmpty else { return }
        
        // Append user's message without animation.
        let userMessage = ChatMessage(id: UUID(), text: userInput, sender: .user)
        chatMessages.append(userMessage)
        
        // Delay before showing typing indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Display typing indicator.
            self.isWaitingForResponse = true
        }
        
        // Call API.
        APIManager.shared.postMessage(text: userInput) { response in
            DispatchQueue.main.async {
                let responseText = response ?? "Sorry, I couldn't understand that."
                let responseMessage = ChatMessage(id: UUID(), text: responseText, sender: .gpt)
                
                withAnimation {
                    self.chatMessages.append(responseMessage)
                    self.isWaitingForResponse = false
                }
            }
        }
        
        userInput = ""
    }
    
    
    struct MessageView: View {
        var message: ChatMessage
        
        var body: some View {
            HStack {
                if message.sender == .gpt {
                    Text(message.text)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("bubbleBackground")))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .foregroundColor(Color("textColor"))
                    Spacer()
                } else {
                    Spacer()
                    Text(message.text)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("userBubbleBackground")))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .foregroundColor(Color("userTextColor"))
                }
            }
            .padding(.horizontal, 15)
        }
    }
    
    
    struct ChatMessage: Identifiable, Equatable {
        let id: UUID
        let text: String
        let sender: Sender
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

struct FadeInModifier: ViewModifier {
    @State private var isVisible: Bool = false
    var delay: Double  // Add a delay property
    
    init(delay: Double = 0) {
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {  // Add the delay here
                    withAnimation(.easeIn(duration: 0.4)) {
                        isVisible = true
                    }
                }
            }
    }
}
    
    extension UIApplication {
        func endEditing() {
            sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        
    }

extension Color {
    static let background = Color("background")
    static let bubbleBackground = Color("bubbleBackground")
    static let textColor = Color("textColor")
    static let userBubbleBackground = Color("userBubbleBackground")
    static let userTextColor = Color("userTextColor")
    static let accentColor = Color("accentColor")
    static let iconColor = Color("iconColor")
    // ... add other colors as needed
}

    

