import SwiftUI

// MARK: - Models
struct AnimationExample: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

// MARK: - ViewModel
@Observable class AnimationViewModel {
    var examples: [AnimationExample] = [
        AnimationExample(
            title: "Basic Animation",
            description: "Simple animation with implicit animation modifier",
            systemImage: "arrow.up.and.down"
        ),
        AnimationExample(
            title: "Spring Animation",
            description: "Physics-based spring animation",
            systemImage: "spring"
        ),
        AnimationExample(
            title: "Transition Animation",
            description: "View transitions with combined effects",
            systemImage: "arrow.triangle.2.circlepath"
        ),
        AnimationExample(
            title: "Matched Geometry",
            description: "Hero animation with matched geometry effect",
            systemImage: "rectangle.2.swap"
        ),
        AnimationExample(
            title: "Phase Animator",
            description: "Multi-step animation with phases",
            systemImage: "list.bullet.clipboard"
        )
    ]
}

// MARK: - Views
struct BasicAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(isAnimating ? 1.5 : 1.0)
                .animation(.easeInOut(duration: 1.0), value: isAnimating)
            
            Button("Animate") {
                isAnimating.toggle()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct SpringAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.green)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.spring(response: 0.5, dampingFraction: 0.5), value: isAnimating)
            
            Button("Spring") {
                isAnimating.toggle()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct TransitionAnimationView: View {
    @State private var isShowing = false
    
    var body: some View {
        VStack {
            if isShowing {
                Text("Hello, SwiftUI!")
                    .font(.title)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Button("Toggle") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowing.toggle()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

struct MatchedGeometryView: View {
    @State private var isExpanded = false
    @Namespace private var animation
    
    var body: some View {
        VStack {
            if isExpanded {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.purple)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .matchedGeometryEffect(id: "shape", in: animation)
                    .overlay(
                        Text("Expanded")
                            .foregroundColor(.white)
                    )
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.purple)
                    .frame(width: 100, height: 100)
                    .matchedGeometryEffect(id: "shape", in: animation)
                    .overlay(
                        Text("Tap")
                            .foregroundColor(.white)
                    )
            }
            
            Button("Toggle") {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct PhaseAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .fill(.orange)
                .frame(width: 100, height: 100)
                .scaleEffect(isAnimating ? 1.5 : 1.0)
                .opacity(isAnimating ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
            
            Button("Start Animation") {
                isAnimating.toggle()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct AnimationsAndMotion: View {
    @State private var viewModel = AnimationViewModel()
    @State private var selectedExample: AnimationExample?
    
    var body: some View {
        List(viewModel.examples) { example in
            Button {
                selectedExample = example
            } label: {
                HStack {
                    Image(systemName: example.systemImage)
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading) {
                        Text(example.title)
                            .font(.headline)
                        Text(example.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Animations")
        .sheet(item: $selectedExample) { example in
            NavigationStack {
                Group {
                    switch example.title {
                    case "Basic Animation":
                        BasicAnimationView()
                    case "Spring Animation":
                        SpringAnimationView()
                    case "Transition Animation":
                        TransitionAnimationView()
                    case "Matched Geometry":
                        MatchedGeometryView()
                    case "Phase Animator":
                        PhaseAnimationView()
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
        AnimationsAndMotion()
    }
} 