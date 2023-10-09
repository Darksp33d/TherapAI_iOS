import SwiftUI

enum Sender {
    case user
    case gpt
}

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var isWaitingForResponse: Bool = false

    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Chat Box t
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(chatMessages) { message in
                            MessageView(message: message)
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
                    }
                    .padding(.vertical)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 10)

                // Message Input
                HStack {
                    TextField("Enter your message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                }
                .padding([.top, .leading, .trailing])
            }
            .padding(.bottom, keyboard.currentHeight + 20)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func sendMessage() {
        guard !userInput.isEmpty else { return }
        
        // Append user's message without animation.
        let userMessage = ChatMessage(id: UUID(), text: userInput, sender: .user)
        chatMessages.append(userMessage)

        // Display typing indicator.
        isWaitingForResponse = true

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
    @State private var isVisible: Bool = false
    
    var body: some View {
        HStack {
            if message.sender == .gpt {
                Text(message.text)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .modifier(FadeInModifier())
                Spacer()
            } else {
                Spacer()
                Text(message.text)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .modifier(FadeInModifier())
            }
        }
    }
}

struct FadeInModifier: ViewModifier {
    @State private var isVisible: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeIn(duration: 0.4)) {
                    isVisible = true
                }
            }
    }
}

struct ChatMessage: Identifiable {
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
