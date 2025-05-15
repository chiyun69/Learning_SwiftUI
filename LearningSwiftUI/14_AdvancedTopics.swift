import SwiftUI
import WebKit
import AVFoundation

// MARK: - Models
struct AdvancedTopic: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

// MARK: - ViewModel
@Observable class AdvancedTopicsViewModel {
    var topics: [AdvancedTopic] = [
        AdvancedTopic(
            title: "Concurrency",
            description: "Demonstrates async/await and actors",
            systemImage: "arrow.triangle.branch"
        ),
        AdvancedTopic(
            title: "Custom Layout",
            description: "Shows custom layout implementation",
            systemImage: "square.grid.3x3"
        ),
        AdvancedTopic(
            title: "Permissions",
            description: "Demonstrates camera permission handling",
            systemImage: "camera"
        ),
        AdvancedTopic(
            title: "UIKit Integration",
            description: "Shows WebView integration",
            systemImage: "globe"
        )
    ]
}

// MARK: - Actor Example
actor UserProfileCache {
    private var profiles: [String: String] = [:]
    
    func setProfile(_ profile: String, forId id: String) {
        profiles[id] = profile
    }
    
    func getProfile(forId id: String) -> String? {
        return profiles[id]
    }
}

// MARK: - Custom Layout
struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        let spacing: CGFloat = 8
        let maxWidth = proposal.width ?? .infinity
        
        var offsets: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxY: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            offsets.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxY = max(maxY, currentY + size.height)
        }
        
        return (offsets, CGSize(width: maxWidth, height: maxY))
    }
}

// MARK: - Views
struct ConcurrencyDemo: View {
    @State private var cache = UserProfileCache()
    @State private var profiles: [String: String] = [:]
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading profiles...")
            } else {
                List {
                    ForEach(Array(profiles.keys.sorted()), id: \.self) { id in
                        HStack {
                            Text("User \(id)")
                            Spacer()
                            Text(profiles[id] ?? "No profile")
                        }
                    }
                }
            }
            
            Button("Load Profiles") {
                loadProfiles()
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func loadProfiles() {
        isLoading = true
        
        Task {
            // Simulate concurrent profile loading
            async let profile1 = loadProfile(id: "1")
            async let profile2 = loadProfile(id: "2")
            async let profile3 = loadProfile(id: "3")
            
            let (p1, p2, p3) = await (profile1, profile2, profile3)
            
            await cache.setProfile(p1, forId: "1")
            await cache.setProfile(p2, forId: "2")
            await cache.setProfile(p3, forId: "3")
            
            // Update UI on main thread
            await MainActor.run {
                profiles = [
                    "1": p1,
                    "2": p2,
                    "3": p3
                ]
                isLoading = false
            }
        }
    }
    
    private func loadProfile(id: String) async -> String {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return "Profile \(id) loaded"
    }
}

struct CustomLayoutDemo: View {
    @State private var items = (1...20).map { "Item \($0)" }
    
    var body: some View {
        ScrollView {
            FlowLayout {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct PermissionsDemo: View {
    @State private var cameraPermission: AVAuthorizationStatus = .notDetermined
    @State private var showingPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            switch cameraPermission {
            case .notDetermined:
                Button("Request Camera Permission") {
                    requestCameraPermission()
                }
                .buttonStyle(.bordered)
                
            case .restricted, .denied:
                Text("Camera access is restricted")
                    .foregroundColor(.red)
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.bordered)
                
            case .authorized:
                Text("Camera access granted")
                    .foregroundColor(.green)
                
            @unknown default:
                Text("Unknown permission status")
            }
        }
        .padding()
        .alert("Camera Permission", isPresented: $showingPermissionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Camera access is required for this feature")
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                cameraPermission = granted ? .authorized : .denied
                if !granted {
                    showingPermissionAlert = true
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct UIKitIntegrationDemo: View {
    var body: some View {
        WebView(url: URL(string: "https://www.apple.com")!)
            .edgesIgnoringSafeArea(.all)
    }
}

struct AdvancedTopics: View {
    @State private var viewModel = AdvancedTopicsViewModel()
    @State private var selectedTopic: AdvancedTopic?
    
    var body: some View {
        List(viewModel.topics) { topic in
            Button {
                selectedTopic = topic
            } label: {
                HStack {
                    Image(systemName: topic.systemImage)
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading) {
                        Text(topic.title)
                            .font(.headline)
                        Text(topic.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Advanced Topics")
        .sheet(item: $selectedTopic) { topic in
            NavigationStack {
                Group {
                    switch topic.title {
                    case "Concurrency":
                        ConcurrencyDemo()
                    case "Custom Layout":
                        CustomLayoutDemo()
                    case "Permissions":
                        PermissionsDemo()
                    case "UIKit Integration":
                        UIKitIntegrationDemo()
                    default:
                        Text("Example not found")
                    }
                }
                .navigationTitle(topic.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            selectedTopic = nil
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AdvancedTopics()
    }
} 