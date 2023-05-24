//
//  NewsHeadlineView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Kingfisher

struct NewsHeadlineView: View {
    
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            if post._embedded?.featuredmedia != nil{
                GeometryReader { geometry in
                    KFImage(source: .network(
                        post._embedded?.featuredmedia?.first?.media_details?.sizes?.medium?.source_url != "" ?
                            URL(string: (post._embedded?.featuredmedia?.first?.media_details?.sizes?.medium?.source_url)!)!
                            :
                            URL(string: EMPTY_IMAGE_URL)!
                    ))
                    .loadImmediately()
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 300)
                    .cornerRadius(8.0)
                    
                }
                .frame(height: 300)
            }
            
            
            VStack(alignment: .leading, spacing: 8.0, content: {
                Text(post.title.rendered.decodingHTMLEntities()).font(.title).lineLimit(2)
                Text(post.date.toDate())
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text(post.content.rendered.decodingHTMLEntities()).lineLimit(3).font(.subheadline)
            })
            
        }
        .padding(8.0)
    }
}

struct NewsHeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        NewsHeadlineView(post: Post.default)
    }
}
