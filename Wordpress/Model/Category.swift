//
//  Category.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import SwiftUI

struct Category: Codable, Identifiable {
    let id: Int
    let count: Int
    let name: String
    
    static var `default` : Category {
        Category(id: 0, count: 5, name: "Category")
    }
    
    static var `default2` : Category {
        Category(id: 0, count: 5555, name: "Category")
    }
    
    static var `home` : Category {
        Category(id: 0, count: 5555, name: "Home")
    }
}
