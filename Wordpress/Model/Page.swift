//
//  Page.swift
//  News
//
//  Created by Asil Arslan on 24.12.2020.
//

import Foundation
import SwiftUI

struct Page: Codable, Identifiable {
    let id: Int
    let date: String
    let title: Rendered
    let content: Rendered
    let excerpt: Rendered
    //    let jetpack_featured_media_url: String?
    let link: String
    var _embedded:Embedded?
    
    static var `default` : Page {
        Page(id: 0, date: "2020-12-18T16:45:09", title: Rendered(rendered: ""), content: Rendered(rendered: ""), excerpt: Rendered(rendered: ""), link: "")
    }
    
}
