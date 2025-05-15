import SwiftUI

// MARK: - Models
struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

// MARK: - ViewModel
@Observable class PostsViewModel {
    private(set) var posts: [Post] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    func fetchPosts() async {
        isLoading = true
        error = nil
        
        do {
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
            
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            posts = decodedPosts
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - Views
struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
            
            Text(post.body)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text("User ID: \(post.userId)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error Loading Posts")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct WorkingWithDataAndNetworking: View {
    @State private var viewModel = PostsViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading posts...")
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    Task {
                        await viewModel.fetchPosts()
                    }
                }
            } else if viewModel.posts.isEmpty {
                ContentUnavailableView(
                    "No Posts",
                    systemImage: "doc.text",
                    description: Text("Pull to refresh or tap the refresh button to load posts")
                )
            } else {
                List(viewModel.posts) { post in
                    PostRow(post: post)
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.fetchPosts()
                }
            }
        }
        .navigationTitle("Posts")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.fetchPosts()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isLoading)
            }
        }
        .task {
            await viewModel.fetchPosts()
        }
    }
}

#Preview {
    NavigationStack {
        WorkingWithDataAndNetworking()
    }
} 