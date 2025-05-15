import SwiftUI

// Model for our list items
struct ListItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

// Detail view for list items
struct DetailView: View {
    let item: ListItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(item.title)
                .font(.largeTitle)
                .bold()
            
            Text(item.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}

// Modal view to be presented
struct ModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("This is a Modal View")
                    .font(.title)
                
                Text("You can dismiss this view by tapping the button below or using the close button in the navigation bar.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button("Dismiss Modal") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("Modal View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NavigationAndDataFlow: View {
    // Sample data for our list
    private let items = [
        ListItem(title: "First Item", description: "This is the description for the first item. It contains some details about the item."),
        ListItem(title: "Second Item", description: "This is the description for the second item. It contains some details about the item."),
        ListItem(title: "Third Item", description: "This is the description for the third item. It contains some details about the item."),
        ListItem(title: "Fourth Item", description: "This is the description for the fourth item. It contains some details about the item.")
    ]
    
    // State for modal presentation
    @State private var isModalPresented = false
    
    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text("Navigation Examples")
            }
            
            Section {
                Button("Present Modal View") {
                    isModalPresented = true
                }
            } header: {
                Text("Modal Presentation")
            }
        }
        .navigationTitle("Navigation & Data Flow")
        .sheet(isPresented: $isModalPresented) {
            ModalView()
        }
    }
}

#Preview {
    NavigationStack {
        NavigationAndDataFlow()
    }
} 