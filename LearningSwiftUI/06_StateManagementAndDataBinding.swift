import SwiftUI

// Observable class for user settings
@Observable class UserSettings {
    var username: String = ""
    var isDarkMode: Bool = false
    var fontSize: Double = 16.0
}

// SubView with binding
struct SettingsToggleView: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Dark Mode")
                .font(.headline)
            
            Toggle("Enable Dark Mode", isOn: $isDarkMode)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StateManagementAndDataBinding: View {
    // State for local toggle
    @State private var isToggleOn = false
    
    // State for subview binding
    @State private var isDarkMode = false
    
    // StateObject for user settings
    @State private var userSettings = UserSettings()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Exercise 1: Basic @State
                VStack(alignment: .leading) {
                    Text("Basic @State Example")
                        .font(.headline)
                    
                    Toggle("Toggle Switch", isOn: $isToggleOn)
                        .padding(.horizontal)
                    
                    Text(isToggleOn ? "Toggle is ON" : "Toggle is OFF")
                        .foregroundColor(isToggleOn ? .green : .red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Exercise 2: @Binding
                VStack(alignment: .leading) {
                    Text("@Binding Example")
                        .font(.headline)
                    
                    SettingsToggleView(isDarkMode: $isDarkMode)
                    
                    Text("Dark mode is \(isDarkMode ? "enabled" : "disabled")")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Exercise 3: @Observable
                VStack(alignment: .leading) {
                    Text("@Observable Example")
                        .font(.headline)
                    
                    TextField("Username", text: $userSettings.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Toggle("Dark Mode", isOn: $userSettings.isDarkMode)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Font Size: \(Int(userSettings.fontSize))")
                        Slider(value: $userSettings.fontSize, in: 12...24, step: 1)
                    }
                    .padding(.horizontal)
                    
                    if !userSettings.username.isEmpty {
                        Text("Hello, \(userSettings.username)!")
                            .font(.system(size: userSettings.fontSize))
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("State Management")
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    NavigationStack {
        StateManagementAndDataBinding()
    }
} 