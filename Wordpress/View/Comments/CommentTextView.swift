//
//  CommentTextView.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import SwiftUI

struct CommentTextView: View {
    @State private var webViewHeight: CGFloat = .zero
    let comment: Comment
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0, content: {
            HStack(spacing: 8.0) {
                Text(comment.author_name).font(.headline).lineLimit(2)
                Spacer()
                Text(comment.date.toDate()).lineLimit(4).font(.footnote).foregroundColor(.gray)
            }
            WebView(dynamicHeight: $webViewHeight,htmlContent: comment.content.rendered)
                .font(.subheadline)
                .frame(height: webViewHeight)
            
        })
        .padding(16.0)
    }
}

struct CommentTextView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextView(comment: Comment.default)
    }
}
