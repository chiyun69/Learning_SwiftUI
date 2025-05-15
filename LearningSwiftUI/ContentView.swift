//
//  ContentView.swift
//  LearningSwiftUI
//
//  Created by Chi Zhuang Yan on 14/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("1. Swift & SwiftUI Fundamentals") {
                    SwiftSwiftUIFundamentals()
                }
                NavigationLink("2. Building UI Views and Controls") {
                    BuildingUIViewsAndControls()
                }
                NavigationLink("3. Layouts and Stacks") {
                    LayoutsAndStacks()
                }
                NavigationLink("4. Navigation and Data Flow") {
                    NavigationAndDataFlow()
                }
                NavigationLink("5. Handling User Input") {
                    HandlingUserInput()
                }
                NavigationLink("6. State Management & Data Binding") {
                    StateManagementAndDataBinding()
                }
                NavigationLink("7. MVVM Architecture with Observable") {
                    MVVMArchitectureWithObservable()
                }
                NavigationLink("8. Working with Data and Networking") {
                    WorkingWithDataAndNetworking()
                }
                NavigationLink("9. Working with Images and Media") {
                    WorkingWithImagesAndMedia()
                }
                NavigationLink("10. Dependency Management & Injection") {
                    DependencyManagementAndInjection()
                }
                NavigationLink("11. Animations and Motion") {
                    AnimationsAndMotion()
                }
                NavigationLink("12. Testing and Debugging") {
                    TestingAndDebugging()
                }
                NavigationLink("13. Performance Optimization") {
                    PerformanceOptimization()
                }
                NavigationLink("14. Advanced Topics") {
                    AdvancedTopics()
                }
            }
            .navigationTitle("Learning SwiftUI")
        }
    }
}

#Preview {
    ContentView()
}
