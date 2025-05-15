import SwiftUI

struct BuildingUIViewsAndControls: View {
    @State private var textInput = ""
    @State private var isToggleOn = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Exercise 1 & 2: TextField with Text display
                VStack(alignment: .leading) {
                    Text("Text Input Example")
                        .font(.headline)
                    
                    TextField("Enter some text", text: $textInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Text("You entered: \(textInput)")
                        .foregroundColor(.secondary)
                    
                    Button("Clear Text") {
                        textInput = ""
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Exercise 3: Toggle switch
                VStack(alignment: .leading) {
                    Text("Toggle Example")
                        .font(.headline)
                    
                    Toggle("Toggle Switch", isOn: $isToggleOn)
                        .padding(.horizontal)
                    
                    Text(isToggleOn ? "Toggle is ON" : "Toggle is OFF")
                        .foregroundColor(isToggleOn ? .green : .red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Exercise 4: AsyncImage
                VStack(alignment: .leading) {
                    Text("Async Image Example")
                        .font(.headline)
                    
                    AsyncImage(url: URL(string: "https://picsum.photos/200/300")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("UI Views & Controls")
    }
}

#Preview {
    NavigationStack {
        BuildingUIViewsAndControls()
    }
}