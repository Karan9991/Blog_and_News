//
//  NewsRowView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Kingfisher

struct PostRowView: View {
    let post:Post
    @State private var webViewHeight: CGFloat = .zero
    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            if post._embedded?.featuredmedia != nil && verifyUrl(urlString: post._embedded?.featuredmedia?.first?.media_details?.sizes?.medium?.source_url){
                KFImage(URL(string: (post._embedded?.featuredmedia?.first?.media_details?.sizes?.medium?.source_url)!) ?? URL(string: EMPTY_IMAGE_URL)!)
                    
                                        .loadImmediately()
                .renderingMode(.original)
                    .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(8.0)
            }
            
            VStack(alignment: .leading, spacing: 4.0, content: {
                Text(post.title.rendered.decodingHTMLEntities())
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(Color("ColorBlack"))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Text(post.excerpt.rendered.decodingHTMLEntities())
                    .font(.body)
                    .lineLimit(2)
                    .foregroundColor(Color("ColorBlack"))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
//                WebView(dynamicHeight: $webViewHeight,htmlContent: post.excerpt.rendered)
//                    .font(.subheadline)
//                    .frame(height: 70)
                Spacer()
                Text(post.date.toDate())
                    .foregroundColor(.gray)
                    .font(.subheadline)
            })
            
            Spacer()
        }
        .padding(8.0)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

}

struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: Post.default)
    }
}
