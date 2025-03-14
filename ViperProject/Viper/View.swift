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

// SwiftUI implementation of the View
struct UserListView: View, AnyView {
    var presenter: AnyPresenter?
    
    // Changed to @Binding to receive updates from UIHostingController
    @Binding var users: [User]
    @Binding var errorMessage: String
    @Binding var showError: Bool
    
    var body: some View {
        NavigationView {
            Group {
                if users.isEmpty && !showError {
                    ProgressView("Loading users...")
                } else if showError {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                        Button("Retry") {
                            presenter?.interactor?.getUSers()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    List {
                        ForEach(users) { user in
                            Text(user.name)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Users")
        }
        .onAppear {
            presenter?.interactor?.getUSers()
        }
    }
    
    // These methods are only needed for protocol conformance
    // The actual updates happen via @Binding
    func update(with users: [User]) {
        // Implementation needed for protocol conformance
        // Actual updates come through @Binding
    }
    
    func update(with error: String) {
        // Implementation needed for protocol conformance
        // Actual updates come through @Binding
    }
}

// UIHostingController to bridge SwiftUI and UIKit for VIPER architecture
class UserViewController: UIHostingController<UserListView>, AnyView {
    var presenter: AnyPresenter?
    
    // State that will be passed to the SwiftUI view
    private var users: [User] = [] {
        didSet { updateView() }
    }
    private var errorMessage: String = "" {
        didSet { updateView() }
    }
    private var showError: Bool = false {
        didSet { updateView() }
    }
    
    init() {
        // Create state objects for the bindings
        let rootView = UserListView(
            presenter: nil,
            users: .constant([]),
            errorMessage: .constant(""),
            showError: .constant(false)
        )
        super.init(rootView: rootView)
        updateView()
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Update the SwiftUI view with current state
    private func updateView() {
        // This ensures our SwiftUI view gets the latest state
        rootView = UserListView(
            presenter: presenter,
            users: .constant(users),
            errorMessage: .constant(errorMessage),
            showError: .constant(showError)
        )
    }
    
    // AnyView protocol implementation
    func update(with users: [User]) {
        print("Received users in ViewController: \(users.count)")
        // Update on main thread and trigger view refresh
        DispatchQueue.main.async {
            self.users = users
            self.showError = false
        }
    }
    
    func update(with error: String) {
        print("Received error in ViewController: \(error)")
        // Update on main thread and trigger view refresh
        DispatchQueue.main.async {
            self.errorMessage = error
            self.showError = true
        }
    }
}

