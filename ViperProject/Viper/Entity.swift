//
//  Entity.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 13/03/25.
//

import Foundation

// Updated User model to match the JSONPlaceholder API response format
struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    
    // For Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
