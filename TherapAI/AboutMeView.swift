import SwiftUI

struct AboutMeView: View {
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 40) {
            Text("About Me")
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundColor(Color.gray.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Your Name")
                    .font(.headline)
                    .foregroundColor(Color.gray.opacity(0.7))
                
                TextField("Enter your name", text: $name)
                    .autocapitalization(.words)
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.background.opacity(0.9)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
            }
            
            Button(action: {
                UserDefaults.standard.set(name, forKey: "userName")
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
                    .font(.headline)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 15)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 50)
    }
}
