import SwiftUI

// MARK: - Service Protocols
protocol DataFetchingService {
    func fetchData() async throws -> String
}

protocol UserPreferencesService {
    var isDarkMode: Bool { get set }
    var fontSize: Double { get set }
}

// MARK: - Service Implementations
class RealDataService: DataFetchingService {
    func fetchData() async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "Data from real service"
    }
}

class MockDataService: DataFetchingService {
    func fetchData() async throws -> String {
        return "Mock data for testing"
    }
}

class UserPreferencesServiceImpl: UserPreferencesService {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("fontSize") var fontSize: Double = 16.0
}

// MARK: - ViewModel
@Observable class ContentViewModel {
    private let dataService: DataFetchingService
    private var preferencesService: UserPreferencesService
    
    var data: String = ""
    var isLoading = false
    var error: Error?
    
    init(dataService: DataFetchingService, preferencesService: UserPreferencesService) {
        self.dataService = dataService
        self.preferencesService = preferencesService
    }
    
    func loadData() async {
        isLoading = true
        error = nil
        
        do {
            data = try await dataService.fetchData()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    var isDarkMode: Bool {
        get { preferencesService.isDarkMode }
        set { preferencesService.isDarkMode = newValue }
    }
    
    var fontSize: Double {
        get { preferencesService.fontSize }
        set { preferencesService.fontSize = newValue }
    }
}

// MARK: - Views
struct ContentView2: View {
    @State private var viewModel: ContentViewModel
    
    init(viewModel: ContentViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Data Section
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    Text(viewModel.data)
                        .font(.system(size: viewModel.fontSize))
                }
                
                Button("Load Data") {
                    Task {
                        await viewModel.loadData()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Preferences Section
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                
                VStack(alignment: .leading) {
                    Text("Font Size: \(Int(viewModel.fontSize))")
                    Slider(value: $viewModel.fontSize, in: 12...24, step: 1)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Dependency Injection")
    }
}

// MARK: - Preview Provider
struct DependencyManagementAndInjection: View {
    // Create real services for production
    private let realDataService = RealDataService()
    private let preferencesService = UserPreferencesServiceImpl()
    
    var body: some View {
        ContentView2(viewModel: ContentViewModel(
            dataService: realDataService,
            preferencesService: preferencesService
        ))
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        // Use mock service for preview
        ContentView2(viewModel: ContentViewModel(
            dataService: MockDataService(),
            preferencesService: UserPreferencesServiceImpl()
        ))
    }
} 
