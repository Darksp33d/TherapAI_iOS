import SwiftUI

struct AboutMeView: View {
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("About Me Page")
            
            TextField("Enter your name", text: $name)
                .autocapitalization(.words)
                .padding()
                .border(Color.gray, width: 0.5)
            
            Button("Submit") {
                UserDefaults.standard.set(name, forKey: "userName")
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
