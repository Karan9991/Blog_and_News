//
//  CommentView.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    let comment: Comment
    var body: some View {
        HStack(alignment: .top, spacing: 12.0) {
            if comment.author_avatar_urls != nil {
                KFImage(source: .network(
                    comment.author_avatar_urls!._96 != "" ?
                        URL(string: (comment.author_avatar_urls!._96))!
                        :
                        URL(string: EMPTY_IMAGE_URL)!
                ))
                .loadImmediately()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
            }
            
            CommentTextView(comment: comment)
                .background(Color(UIColor.systemGray.withAlphaComponent(0.1)))
                .cornerRadius(16.0)
            Spacer()
        }
        .padding(.leading, 16)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment.default)
    }
}
