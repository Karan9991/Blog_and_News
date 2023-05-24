//
//  Comment.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import Foundation

struct Comment: Codable, Identifiable {
    var id: Int
    let author_name: String
    let content: Rendered
    let date: String
    let author_avatar_urls: AvatarURL?
    
    static var `default` : Comment {
        Comment(id: 0, author_name: "", content: Rendered(rendered: ""), date: "", author_avatar_urls: AvatarURL(_96: ""))
    }
}

struct AvatarURL : Codable{
    
    enum CodingKeys: String, CodingKey {
            case _96 = "96"
    }
    let _96 : String
    
}
