//
//  Tag.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import Foundation
import SwiftUI

struct Tag: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    
    static var `default` : Tag {
        Tag(id: 0, name: "Tag")
    }
}
