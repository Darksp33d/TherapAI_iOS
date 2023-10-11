import SwiftUI

struct AboutMeView: View {
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("About Me")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer().frame(height: 40)
            
            TextField("Enter your name", text: $name)
                .font(.title2)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .padding(.horizontal)
            
            Spacer().frame(height: 40)
            
            Button(action: {
                UserDefaults.standard.set(name, forKey: "userName")
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 40)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding()
    }
}
