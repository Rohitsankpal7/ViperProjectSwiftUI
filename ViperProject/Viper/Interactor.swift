//
//  Interactor.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 13/03/25.
//

import Foundation

enum FetchError: Error {
    case networkError
    case decodingError
    case failed
}

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUSers()
}

class UserInteractor: AnyInteractor {
    var presenter: (any AnyPresenter)?
    
    func getUSers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { 
            self.presenter?.interactorDidfetchUsers(with: .failure(FetchError.failed))
            return 
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.presenter?.interactorDidfetchUsers(with: .failure(FetchError.networkError))
                return
            }
            
            guard let data = data else {
                self.presenter?.interactorDidfetchUsers(with: .failure(FetchError.failed))
                return
            }
            
            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                self.presenter?.interactorDidfetchUsers(with: .success(entities))
            } catch {
                self.presenter?.interactorDidfetchUsers(with: .failure(error))
            }
        }
        task.resume()
    }
}
