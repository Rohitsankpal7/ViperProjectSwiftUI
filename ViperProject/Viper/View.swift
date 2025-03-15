//
//  View.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 13/03/25.
//

import Foundation
import SwiftUI

// Protocol for the View in VIPER architecture
protocol AnyView {
    var presenter: AnyPresenter? { get set }
    func update(with users: [User])
    func update(with error: String)
}

/// SwiftUI View that conforms to AnyView protocol in VIPER architecture
struct UserListView: View, AnyView {
    // ViewModel to handle state and data presentation
    @ObservedObject private var viewModel = UserViewModel()
    
    // Presenter property that will be set by the router
    var presenter: AnyPresenter? {
        didSet {
            // When presenter is set, pass it to the view model
            viewModel.presenter = presenter
        }
    }
    
    // State property to force view updates when data changes
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationView {
            VStack {
                // Main content based on loading state
                if viewModel.isLoading && viewModel.users.isEmpty {
                    Spacer()
                    ProgressView("Loading users...")
                    Spacer()
                } else if viewModel.showError {
                    Spacer()
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Retry") {
                            viewModel.fetchUsers()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    Spacer()
                } else {
                    // User list 
                    if viewModel.users.isEmpty {
                        Spacer()
                        Text("No users found")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.users) { user in
                                    HStack {
                                        Text(user.name)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
            }
            .id(refreshID) // Force view to refresh when this changes
            .navigationTitle("Users")
        }
        .onAppear {
            // Ensure presenter is connected
            if viewModel.presenter == nil {
                viewModel.presenter = presenter
            }
            
            // Fetch data when view appears
            viewModel.fetchUsers()
        }
    }
    
    // MARK: - AnyView Protocol Implementation
    
    /// Updates the view with fetched users
    func update(with users: [User]) {
        DispatchQueue.main.async {
            self.viewModel.users = users
            self.viewModel.isLoading = false
            self.viewModel.showError = false
            
            // Force view to refresh
            self.refreshID = UUID()
        }
    }
    
    /// Updates the view with an error message
    func update(with error: String) {
        DispatchQueue.main.async {
            self.viewModel.errorMessage = error
            self.viewModel.isLoading = false
            self.viewModel.showError = true
            
            // Force view to refresh
            self.refreshID = UUID()
        }
    }
    
    /// Public method to trigger data fetch from outside the view
    func fetchData() {
        viewModel.fetchUsers()
    }
}

