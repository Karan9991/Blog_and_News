//
//  TitleAndDateView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct TitleAndDateView: View {
    
    let post:Post

    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing:10) {
                Text(post.title.rendered.decodingHTMLEntities())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(4)
                
                Text(post.date.toDate())
                    .font(.body)
                    .foregroundColor(Color("ColorHeadlineDate"))
            }
            Spacer()
        }
    }
}

struct TitleAndDateView_Previews: PreviewProvider {
    static var previews: some View {
        TitleAndDateView(post: Post.default)
            .background(Color.black)
    }
}
