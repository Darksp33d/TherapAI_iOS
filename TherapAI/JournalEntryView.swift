import SwiftUI

struct JournalEntryView: View {
    @State private var journalContent: String = ""
    @State private var entrySubmitted: Bool = false

    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Journal Entry")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .foregroundColor(Color.textColor)

                ZStack(alignment: .topLeading) {
                    if journalContent.isEmpty {
                        Text("Log your entry here...")
                            .foregroundColor(Color.gray)
                            .padding(.all, 15)
                    }
                    
                    TextEditor(text: $journalContent)
                        .background(Color.background) // Set the background color to match
                        .clipShape(RoundedRectangle(cornerRadius: 20)) // Add this to match the rounded shape of the border
                }
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.accentColor, lineWidth: 2))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                Button(action: {
                    if journalContent.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        APIManager.shared.addJournalEntry(content: journalContent) { success in
                            if success {
                                entrySubmitted = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    entrySubmitted = false
                                }
                            } else {
                                print("Error saving entry.")
                            }
                        }
                    }
                }) {
                    Text("Log Entry")
                        .font(.headline)
                        .foregroundColor(journalContent.trimmingCharacters(in: .whitespacesAndNewlines) == "" ? Color.gray : Color.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .disabled(journalContent.trimmingCharacters(in: .whitespacesAndNewlines) == "")

                Spacer()
            }
            .padding()

            if entrySubmitted {
                VStack {
                    Spacer()
                    Text("Entry Submitted!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.accentColor)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.background.opacity(0.9)))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    Spacer()
                }
            }
        }
    }
}
