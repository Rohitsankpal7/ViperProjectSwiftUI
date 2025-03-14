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
            interactor?.getUSers()
        }
    }
    
    var view: AnyView?
    
    func interactorDidfetchUsers(with result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            view?.update(with: users)
            
        case .failure(let error):
            print("Decoding error: \(error)")  // For debugging
            view?.update(with: "Failed to decode data: \(error.localizedDescription)")
        }
    }
    
    
}
