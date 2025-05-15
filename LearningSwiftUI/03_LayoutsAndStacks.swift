import SwiftUI

struct LayoutsAndStacks: View {
    // Sample data for LazyVStack demo
    private let items = (1...20).map { "Item \($0)" }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Exercise 1: VStack with spacing
                VStack(spacing: 15) {
                    Text("VStack Example")
                        .font(.headline)
                    
                    Text("First Item")
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text("Second Item")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text("Third Item")
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Exercise 2: HStack with alignment
                VStack(alignment: .leading) {
                    Text("HStack Example")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                        
                        VStack(alignment: .leading) {
                            Text("Aligned Content")
                                .font(.title3)
                            Text("This text is aligned to the top of the star icon")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Exercise 3: ZStack overlay
                VStack(alignment: .leading) {
                    Text("ZStack Example")
                        .font(.headline)
                    
                    ZStack {
                        Image(systemName: "photo")
                            .font(.system(size: 100))
                            .foregroundColor(.gray)
                        
                        Text("Overlay Text")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                    }
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Exercise 4: LazyVStack in ScrollView
                VStack(alignment: .leading) {
                    Text("LazyVStack Example")
                        .font(.headline)
                    
                    LazyVStack(spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Exercise 5: Spacer example
                VStack(alignment: .leading) {
                    Text("Spacer Example")
                        .font(.headline)
                    
                    HStack {
                        Text("Left")
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Text("Right")
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Layouts & Stacks")
    }
}

#Preview {
    NavigationStack {
        LayoutsAndStacks()
    }
} 