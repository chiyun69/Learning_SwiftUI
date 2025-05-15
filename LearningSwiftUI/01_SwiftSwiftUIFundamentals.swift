import SwiftUI

struct GreetingView: View {
    let name: String
    
    var body: some View {
        Text("Hello, \(name)!")
            .font(.title)
            .foregroundColor(.blue)
    }
}

struct SwiftSwiftUIFundamentals: View {
    var body: some View {
        VStack(spacing: 20) {
            // Exercise 1 & 2: Modified Text view
            Text("Welcome to SwiftUI Fundamentals!")
                .font(.largeTitle)
                .foregroundColor(.primary)
            
            // Exercise 3: Image view with SF Symbol
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            // Exercise 4: Custom view with modifiers
            GreetingView(name: "Swift Developer")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    SwiftSwiftUIFundamentals()
} 