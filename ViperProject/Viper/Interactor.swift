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
        print("Fetching users...")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                print("Failed to fetch users.")
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
