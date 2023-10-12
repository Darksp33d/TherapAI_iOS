import SwiftUI

struct JournalEntry: Hashable, Identifiable {
    var id: UUID = UUID()
    var date: String
    var content: String
}

struct JournalEntriesView: View {
    @State private var entries: [JournalEntry] = []
    @State private var selectedEntry: JournalEntry?

    var body: some View {
        VStack(spacing: 20) {
            Text("My Entries")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 25) {  // Increased spacing
                    ForEach(entries) { entry in
                        Button(action: {
                            selectedEntry = entry
                        }) {
                            VStack(alignment: .leading) {  // Aligned to the left
                                Text(entry.content)
                                    .font(.body)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.bubbleBackground, lineWidth: 1)
                                    )
                                Text(entry.date)
                                    .font(.caption)
                                    .padding(.leading)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .background(Color.background)  // Set the background color
        .onAppear {
            APIManager.shared.getJournalEntries { fetchedEntries in
                self.entries = fetchedEntries.map { JournalEntry(date: $0.date, content: $0.content) }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            FullJournalEntryView(entry: entry)
        }
    }
}


struct FullJournalEntryView: View {
    var entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading) {  // Aligned to the left
            Text(entry.date)
                .font(.headline)
                .padding()

            ScrollView {
                Text(entry.content)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)  // Aligned to the left
            }
        }
        .background(Color.background)  // Set the background color
    }
}
