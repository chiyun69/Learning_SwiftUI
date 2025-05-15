import SwiftUI

// MARK: - Models
struct TodoItemTest: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

// MARK: - ViewModel
@Observable class TodoViewTestModel {
    var items: [TodoItemTest] = []
    var newItemTitle: String = ""
    var errorMessage: String?
    var isLoading = false
    
    func addItem() {
        guard !newItemTitle.isEmpty else {
            errorMessage = "Title cannot be empty"
            return
        }
        
        let newItem = TodoItemTest(title: newItemTitle, isCompleted: false)
        items.append(newItem)
        newItemTitle = ""
        errorMessage = nil
    }
    
    func toggleItem(_ item: TodoItemTest) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    func deleteItem(_ item: TodoItemTest) {
        items.removeAll { $0.id == item.id }
    }
    
    func simulateLoading() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

// MARK: - Views
struct TodoItemTestView: View {
    let item: TodoItemTest
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            .accessibilityLabel(item.isCompleted ? "Mark as incomplete" : "Mark as complete")
            
            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundColor(item.isCompleted ? .gray : .primary)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .accessibilityLabel("Delete item")
        }
        .padding(.vertical, 8)
    }
}

struct TestingAndDebugging: View {
    @State private var viewModel = TodoViewTestModel()
    @State private var showingDebugInfo = false
    
    var body: some View {
        VStack {
            // Add new item
            HStack {
                TextField("New item", text: $viewModel.newItemTitle)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("newItemTextField")
                
                Button("Add") {
                    viewModel.addItem()
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("addButton")
            }
            .padding()
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .accessibilityIdentifier("errorMessage")
            }
            
            // Todo list
            List {
                ForEach(viewModel.items) { item in
                    TodoItemTestView(
                        item: item,
                        onToggle: { viewModel.toggleItem(item) },
                        onDelete: { viewModel.deleteItem(item) }
                    )
                    .accessibilityIdentifier("todoItem-\(item.id)")
                }
            }
            
            // Debug controls
            VStack {
                Button("Simulate Loading") {
                    Task {
                        await viewModel.simulateLoading()
                    }
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("simulateLoadingButton")
                
                Button(showingDebugInfo ? "Hide Debug Info" : "Show Debug Info") {
                    showingDebugInfo.toggle()
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("debugToggleButton")
            }
            .padding()
            
            // Debug information
            if showingDebugInfo {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Debug Information")
                        .font(.headline)
                    
                    Text("Items count: \(viewModel.items.count)")
                    Text("Loading: \(viewModel.isLoading ? "Yes" : "No")")
                    Text("Error: \(viewModel.errorMessage ?? "None")")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
            }
        }
        .navigationTitle("Testing & Debugging")
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TestingAndDebugging()
    }
} 
