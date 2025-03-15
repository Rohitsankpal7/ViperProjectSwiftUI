//
//  ViewModel.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 14/03/25.
//
import SwiftUI

/// ViewModel for handling user data and state in the VIPER architecture
class UserViewModel: ObservableObject {
    // Published properties to reflect state in the view
    @Published var users: [User] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = true
    @Published var showError: Bool = false
    
    // Reference to the presenter for VIPER communication
    var presenter: AnyPresenter?
    
    /// Fetches users via the VIPER presenter-interactor chain
    func fetchUsers() {
        // Explicitly notify observers of upcoming changes
        self.objectWillChange.send()
        
        // Update loading state
        isLoading = true
        showError = false
        
        // Request data via presenter
        presenter?.interactor?.getUSers()
    }
    
    /// Legacy method name, now redirects to fetchUsers
    func manuallyFetchUsers() {
        fetchUsers()
    }
}
