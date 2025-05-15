import SwiftUI

struct HandlingUserInput: View {
    // State for tap counter
    @State private var tapCount = 0
    
    // State for drag gesture
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    
    // State for text fields and focus
    @State private var firstName = ""
    @State private var lastName = ""
    @FocusState private var focusedField: Field?
    
    // Enum for text field focus
    enum Field {
        case firstName, lastName
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Exercise 1: Tap gesture with counter
                VStack(alignment: .leading) {
                    Text("Tap Gesture Example")
                        .font(.headline)
                    
                    Circle()
                        .fill(isDragging ? Color.blue : Color.green)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("\(tapCount)")
                                .foregroundColor(.white)
                                .font(.title)
                        )
                        .onTapGesture {
                            tapCount += 1
                        }
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    dragOffset = gesture.translation
                                    isDragging = true
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        dragOffset = .zero
                                        isDragging = false
                                    }
                                }
                        )
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Exercise 2: Drag gesture
                VStack(alignment: .leading) {
                    Text("Drag Gesture Example")
                        .font(.headline)
                    
                    Text("Drag the circle above to move it around")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Exercise 3: Text field with onSubmit
                VStack(alignment: .leading) {
                    Text("Text Field Example")
                        .font(.headline)
                    
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: .firstName)
                        .onSubmit {
                            focusedField = .lastName
                        }
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: .lastName)
                        .onSubmit {
                            focusedField = nil
                        }
                    
                    if !firstName.isEmpty || !lastName.isEmpty {
                        Text("Hello, \(firstName) \(lastName)!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Exercise 4: Focus management
                VStack(alignment: .leading) {
                    Text("Focus Management")
                        .font(.headline)
                    
                    HStack {
                        Button("Focus First Name") {
                            focusedField = .firstName
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Focus Last Name") {
                            focusedField = .lastName
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("User Input")
    }
}

#Preview {
    NavigationStack {
        HandlingUserInput()
    }
} 