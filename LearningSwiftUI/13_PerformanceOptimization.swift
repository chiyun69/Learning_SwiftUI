import SwiftUI

// MARK: - Models
struct PerformanceItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

// MARK: - ViewModel
@Observable class PerformanceViewModel {
    var items: [PerformanceItem] = [
        PerformanceItem(
            title: "Lazy Loading",
            description: "Demonstrates LazyVStack vs VStack performance",
            systemImage: "list.bullet"
        ),
        PerformanceItem(
            title: "Equatable Views",
            description: "Shows how to prevent unnecessary view updates",
            systemImage: "equal.circle"
        ),
        PerformanceItem(
            title: "Image Optimization",
            description: "Demonstrates efficient image loading and caching",
            systemImage: "photo"
        ),
        PerformanceItem(
            title: "State Management",
            description: "Shows efficient state management techniques",
            systemImage: "arrow.triangle.branch"
        )
    ]
}

// MARK: - Views
struct LazyLoadingDemo: View {
    @State private var itemCount = 1000
    
    var body: some View {
        VStack {
            Stepper("Items: \(itemCount)", value: $itemCount, in: 100...10000, step: 100)
                .padding()
            
            ScrollView {
                // Using LazyVStack for better performance
                LazyVStack(spacing: 8) {
                    ForEach(0..<itemCount, id: \.self) { index in
                        Text("Item \(index)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
}

struct EquatableViewDemo: View {
    @State private var counter = 0
    @State private var backgroundColor = Color.blue
    
    var body: some View {
        VStack(spacing: 20) {
            // This view will update only when counter changes
            CounterView(counter: counter)
                .equatable()
            
            // This view will update on every state change
            NonEquatableView(counter: counter, backgroundColor: backgroundColor)
            
            Button("Increment Counter") {
                counter += 1
            }
            .buttonStyle(.bordered)
            
            Button("Change Background") {
                backgroundColor = backgroundColor == .blue ? .green : .blue
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct CounterView: View, Equatable {
    let counter: Int
    
    var body: some View {
        Text("Counter: \(counter)")
            .font(.title)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
    
    static func == (lhs: CounterView, rhs: CounterView) -> Bool {
        lhs.counter == rhs.counter
    }
}

struct NonEquatableView: View {
    let counter: Int
    let backgroundColor: Color
    
    var body: some View {
        Text("Non-Equatable View")
            .font(.title)
            .padding()
            .background(backgroundColor.opacity(0.1))
            .cornerRadius(10)
    }
}

struct ImageOptimizationDemo: View {
    @State private var imageSize: CGFloat = 100
    
    var body: some View {
        VStack {
            // Optimized image loading with AsyncImage
            AsyncImage(url: URL(string: "https://picsum.photos/200")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: imageSize, height: imageSize)
            
            Slider(value: $imageSize, in: 50...200)
                .padding()
            
            Text("Image Size: \(Int(imageSize))")
        }
        .padding()
    }
}

struct StateManagementDemo: View {
    @State private var items: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            
            Button("Load Items") {
                loadItems()
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func loadItems() {
        isLoading = true
        
        // Simulate async work
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            items = (1...100).map { "Item \($0)" }
            isLoading = false
        }
    }
}

struct PerformanceOptimization: View {
    @State private var viewModel = PerformanceViewModel()
    @State private var selectedExample: PerformanceItem?
    
    var body: some View {
        List(viewModel.items) { item in
            Button {
                selectedExample = item
            } label: {
                HStack {
                    Image(systemName: item.systemImage)
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Performance")
        .sheet(item: $selectedExample) { example in
            NavigationStack {
                Group {
                    switch example.title {
                    case "Lazy Loading":
                        LazyLoadingDemo()
                    case "Equatable Views":
                        EquatableViewDemo()
                    case "Image Optimization":
                        ImageOptimizationDemo()
                    case "State Management":
                        StateManagementDemo()
                    default:
                        Text("Example not found")
                    }
                }
                .navigationTitle(example.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            selectedExample = nil
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PerformanceOptimization()
    }
} 