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

    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
            NavigationView {
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        VStack {
                            ScrollView {
                                ScrollViewReader { proxy in
                                    LazyVStack(spacing: 10) {
                                        ForEach(chatMessages) { message in
                                            MessageView(message: message)
                                                .id(message.id)
                                        }
                                        if isWaitingForResponse {
                                            HStack {
                                                TypingIndicatorView()
                                                    .padding()
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(10)
                                                Spacer()
                                            }
                                        }
                                        if keyboard.currentHeight > 0 {
                                            Spacer()
                                                .frame(height: keyboard.currentHeight)
                                        }
                                    }
                                    .padding(.vertical)
                                    .onChange(of: chatMessages) { _ in
                                        if let lastMessage = chatMessages.last {
                                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            
                            HStack {
                                TextField("Enter your message...", text: $userInput)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button(action: sendMessage) {
                                    Text("Send")
                                }
                            }
                            .padding(.bottom, keyboard.currentHeight > 0 ? 20 : 10)
                            .padding([.top, .leading, .trailing])
                        }
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    }
                    .offset(x: isMenuVisible ? UIScreen.main.bounds.width / 3 : 0)


                    if isMenuVisible {
                        SideMenuView(closeAction: {
                            withAnimation(.spring()) {
                                self.isMenuVisible.toggle()
                            }
                        }, navigateToAboutMe: $navigateToAboutMe)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .background(Color.gray)
                        .transition(.move(edge: .leading))
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
                    }
                )
                .background(NavigationLink("", destination: AboutMeView(), isActive: $navigateToAboutMe))
            }
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
}

struct MessageView: View {
    var message: ChatMessage
    
    var body: some View {
        HStack(spacing: 15) {  // <-- Increase spacing between messages
            if message.sender == .gpt {
                Text(message.text)
                    .padding(8)  // <-- Decreased padding for smaller bubbles
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)  // <-- Smaller corner radius
                    .modifier(FadeInModifier())
                Spacer()
            } else {
                Spacer()
                Text(message.text)
                    .padding(8)  // <-- Decreased padding for smaller bubbles
                    .background(Color.blue.opacity(0.5))  // <-- User message background color
                    .cornerRadius(8)  // <-- Smaller corner radius
                    .modifier(FadeInModifier())
            }
        }
        .padding(.horizontal, 10)  // <-- Increase distance from the edge
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

