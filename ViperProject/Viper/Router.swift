//
//  Router.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 13/03/25.
//

import Foundation
import SwiftUI
import UIKit

// For pure SwiftUI, our entry point is a UIHostingController
typealias EntryPoint = UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get }
    static func start() -> AnyRouter
}

/// Router implementation for the User module in VIPER architecture
class UserRouter: AnyRouter {
    var entry: EntryPoint?
    
    /// Initializes and connects all VIPER components
    static func start() -> any AnyRouter {
        let router = UserRouter()
        
        // Create all components
        let presenter = UserPresenter()
        let interactor = UserInteractor()
        var view = UserListView()
        
        // Connect components in the correct order to avoid reference issues
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        // Set the view on the presenter before setting the presenter on the view
        presenter.view = view
        presenter.router = router
        
        // Now set the presenter on the view
        view.presenter = presenter
        
        // Create the hosting controller with the fully configured view
        let hostingController = UIHostingController(rootView: view)
        router.entry = hostingController
        
        return router
    }
}
