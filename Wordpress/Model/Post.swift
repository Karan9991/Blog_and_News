//
//  Post.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct Post: Codable, Identifiable {
    let id: Int
    let date: String
    let title: Rendered
    let content: Rendered
    let excerpt: Rendered
    //    let jetpack_featured_media_url: String?
    let link: String
    var _embedded:Embedded?
    
    static var `default` : Post {
        Post(id: 0, date: "2020-12-18T16:45:09", title: Rendered(rendered: ""), content: Rendered(rendered: ""), excerpt: Rendered(rendered: ""), link: "")
    }
    
    //    required init(from decoder: Decoder) throws {
    //            let values = try decoder.container(keyedBy: CodingKeys.self)
    //        id = try values.decode(Int.self, forKey: .id)
    //        date = try values.decode(String.self, forKey: .date)
    //        title = try values.decode(Rendered.self, forKey: .title)
    //        content = try values.decode(Rendered.self, forKey: .content)
    //        excerpt = try values.decode(Rendered.self, forKey: .excerpt)
    //        link = try values.decode(String.self, forKey: .link)
    //        _embedded = try values.decode(Embedded.self, forKey: ._embedded)
    ////            mess = try values.decode([String].self, forKey: .mess)
    ////            data = try? values.decode(LoginUserResponseData.self, forKey: .data)
    //        }
}


struct Rendered : Codable{
    
    let rendered: String
    
}

struct Embedded : Codable{
    
    enum CodingKeys: String, CodingKey {
        case featuredmedia = "wp:featuredmedia"
    }
    var featuredmedia : [Media]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        featuredmedia = try? values.decode([Media].self, forKey: .featuredmedia)
    }
}


struct Media : Codable{
    
    var source_url: String?
    var media_details: MediaDetails?
    
    init(from decoder: Decoder) throws {
               let values = try decoder.container(keyedBy: CodingKeys.self)
        source_url = try values.decode(String.self, forKey: .source_url)
        media_details = try values.decode(MediaDetails.self, forKey: .media_details)
    }
}

struct MediaDetails : Codable{
    
    var sizes: MediaSizes?
    
    init(from decoder: Decoder) throws {
               let values = try decoder.container(keyedBy: CodingKeys.self)
        sizes = try values.decode(MediaSizes.self, forKey: .sizes)
    }
}

struct MediaSizes : Codable{
    
    var medium: MediaSize?
    
    init(from decoder: Decoder) throws {
               let values = try decoder.container(keyedBy: CodingKeys.self)
        medium = try values.decode(MediaSize.self, forKey: .medium)
    }
}


struct MediaSize : Codable{
    
    var source_url: String?
    
    init(from decoder: Decoder) throws {
               let values = try decoder.container(keyedBy: CodingKeys.self)
        source_url = try values.decode(String.self, forKey: .source_url)
    }
}
