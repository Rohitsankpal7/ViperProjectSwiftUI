//
//  Entity.swift
//  ViperProject
//
//  Created by Rohit Sankpal on 13/03/25.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        // Handle ID from API or generate new one if not present
        if let idString = try? container.decode(String.self, forKey: .id),
           let uuid = UUID(uuidString: idString) {
            id = uuid
        } else {
            id = UUID()
        }
    }
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
