//
//  Presenter.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 13/03/25.
//

import Foundation

protocol AnyPresenter {
    var router: AnyRouter? { get set}
    var interactor: AnyInteractor? { get set}
    var view: AnyView? { get set}
    
    func interactorDidfetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    var router: AnyRouter?
    
    var interactor: AnyInteractor? {
        didSet {
            // Don't automatically fetch users here as it can cause timing issues
            // Let the view trigger the fetch when it's ready
        }
    }
    
    var view: AnyView?
    
    func interactorDidfetchUsers(with result: Result<[User], Error>) {
        print("Presenter received result from interactor")
        
        switch result {
        case .success(let users):
            print("Presenter processing \(users.count) users")
            // Make sure we have a view before trying to update it
            guard let view = view else {
                print("ERROR: View is nil in presenter")
                return
            }
            view.update(with: users)
            
        case .failure(let error):
            print("Presenter processing error: \(error.localizedDescription)")
            guard let view = view else {
                print("ERROR: View is nil in presenter")
                return
            }
            view.update(with: "Failed to fetch users: \(error.localizedDescription)")
        }
    }
}
