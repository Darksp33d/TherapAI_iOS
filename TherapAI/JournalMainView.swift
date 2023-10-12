import SwiftUI

struct Quote {
    var text: String
    var author: String
}

import SwiftUI

struct JournalMainView: View {
    @State private var showEntryView = false
    @State private var showEntriesView = false
    @State private var dailyQuote: Quote = Quote(text: "", author: "")

    let mockQuotes: [Quote] = [
        Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
        Quote(text: "Life is what happens when you’re busy making other plans.", author: "John Lennon"),
        Quote(text: "Success is not final, failure is not fatal: It is the courage to continue that counts.", author: "Winston Churchill"),
        Quote(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
        Quote(text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson"),
    ]

    var body: some View {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("My Journal")
                        .font(.system(size: 45, weight: .bold, design: .default)) // Updated font size and weight
                        .foregroundColor(Color.textColor) // Changed color to emphasize
                        .padding(.bottom, 60) // Added more bottom padding for emphasis
                    
                    VStack {
                        Text("\"\(dailyQuote.text)\"")
                            .font(.title2) // Changed to title2 for a smaller font size
                            .fontWeight(.light)
                            .foregroundColor(Color.gray.opacity(0.8)) // Made the quote color more subtle
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 10)

                        Text("- \(dailyQuote.author)")
                            .font(.subheadline) // Updated to a smaller font for the author
                            .fontWeight(.ultraLight)
                            .foregroundColor(Color.gray.opacity(0.7)) // Made the author color even more subtle
                    }
                    .padding(.bottom, 50)

                HStack(spacing: 40) {
                    actionButton(image: "plus.circle.fill", title: "Log New Entry", action: { showEntryView.toggle() }, isPresented: $showEntryView, view: JournalEntryView())
                    actionButton(image: "book.fill", title: "View Entries", action: { showEntriesView.toggle() }, isPresented: $showEntriesView, view: JournalEntriesView())
                }

                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 50)
        }
        .onAppear {
            loadDailyQuote()
        }
    }
    
    // A sleek action button
    func actionButton<V: View>(image: String, title: String, action: @escaping () -> Void, isPresented: Binding<Bool>, view: V) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: image)
                    .font(.title)
                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
        }
        .sheet(isPresented: isPresented, content: { view })
    }


    func loadDailyQuote() {
        // In reality, this would be fetched from a backend or API
        // For the sake of the example, we'll use a random quote from our mockQuotes array
        if let randomQuote = mockQuotes.randomElement() {
            dailyQuote = randomQuote
        }
    }
}




