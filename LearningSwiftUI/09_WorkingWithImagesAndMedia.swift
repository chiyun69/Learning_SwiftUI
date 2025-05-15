import SwiftUI
import PhotosUI

// MARK: - Models
struct ImageItem: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
}

// MARK: - ViewModel
@Observable class ImageViewModel {
    var selectedItems: [PhotosPickerItem] = []
    private(set) var images: [ImageItem] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    func loadTransferable(from imageSelections: [PhotosPickerItem]) async {
        isLoading = true
        error = nil
        
        do {
            var newImages: [ImageItem] = []
            
            for item in imageSelections {
                if let data = try await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    newImages.append(ImageItem(image: image, title: "Selected Image"))
                }
            }
            
            images = newImages
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - Views
struct ImageGrid: View {
    let images: [ImageItem]
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(images) { item in
                    item.image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .padding()
        }
    }
}

struct ErrorView2: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error Loading Images")
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

struct WorkingWithImagesAndMedia: View {
    @State private var viewModel = ImageViewModel()
    
    var body: some View {
        VStack {
            // Image picker
            PhotosPicker(
                selection: $viewModel.selectedItems,
                maxSelectionCount: 5,
                matching: .images
            ) {
                Label("Select Images", systemImage: "photo.on.rectangle.angled")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            
            // Content
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading images...")
                } else if let error = viewModel.error {
                    ErrorView2(error: error) {
                        Task {
                            await viewModel.loadTransferable(from: viewModel.selectedItems)
                        }
                    }
                } else if viewModel.images.isEmpty {
                    ContentUnavailableView(
                        "No Images",
                        systemImage: "photo",
                        description: Text("Select images from your photo library")
                    )
                } else {
                    ImageGrid(images: viewModel.images)
                }
            }
        }
        .navigationTitle("Images & Media")
        .onChange(of: viewModel.selectedItems) { _, newItems in
            Task {
                await viewModel.loadTransferable(from: newItems)
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkingWithImagesAndMedia()
    }
} 
