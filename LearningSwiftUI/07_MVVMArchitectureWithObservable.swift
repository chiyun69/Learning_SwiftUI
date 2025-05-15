import SwiftUI

// MARK: - Models
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var createdAt: Date
}

// MARK: - ViewModel
@Observable class TodoViewModel {
    private(set) var items: [TodoItem] = []
    var newItemTitle: String = ""
    
    init() {
        // Add some sample items
        items = [
            TodoItem(title: "Learn SwiftUI", isCompleted: false, createdAt: Date()),
            TodoItem(title: "Build an app", isCompleted: false, createdAt: Date()),
            TodoItem(title: "Publish to App Store", isCompleted: false, createdAt: Date())
        ]
    }
    
    func addItem() {
        guard !newItemTitle.isEmpty else { return }
        let newItem = TodoItem(title: newItemTitle, isCompleted: false, createdAt: Date())
        items.append(newItem)
        newItemTitle = ""
    }
    
    func toggleItem(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    func deleteItem(_ item: TodoItem) {
        items.removeAll { $0.id == item.id }
    }
}

// MARK: - Views
struct TodoItemView: View {
    let item: TodoItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            
            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundColor(item.isCompleted ? .gray : .primary)
            
            Spacer()
            
            Text(item.createdAt, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct AddTodoView: View {
    @Binding var title: String
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            TextField("New todo item", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
            }
            .disabled(title.isEmpty)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MVVMArchitectureWithObservable: View {
    @State private var viewModel = TodoViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Add new item section
            AddTodoView(
                title: $viewModel.newItemTitle,
                onAdd: viewModel.addItem
            )
            
            // List of items
            List {
                ForEach(viewModel.items) { item in
                    TodoItemView(
                        item: item,
                        onToggle: { viewModel.toggleItem(item) },
                        onDelete: { viewModel.deleteItem(item) }
                    )
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .navigationTitle("MVVM Todo List")
    }
}

#Preview {
    NavigationStack {
        MVVMArchitectureWithObservable()
    }
} 