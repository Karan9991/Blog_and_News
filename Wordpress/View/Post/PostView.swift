//
//  NewsView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var webViewHeight: CGFloat = .zero
    
//    var interstitial:Interstitial = Interstitial()
    
    let new: Post
    var body: some View {
        // use GeometryReader to get current frame
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false, content: {
                if new._embedded?.featuredmedia != nil {
                    KFImage(source: .network(URL(string: (new._embedded?.featuredmedia?.first?.source_url)!) ?? URL(string: EMPTY_IMAGE_URL)!))
                    .loadImmediately()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height / 3)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8.0, content: {
                    Text(new.title.rendered.decodingHTMLEntities()).font(.largeTitle)
                    Text(new.date.toDate())
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium, design: .default))
                    SocialCountView(new:new).padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                    WebView(dynamicHeight: $webViewHeight,htmlContent: new.content.rendered)
                        .font(.subheadline)
                        .frame(height: webViewHeight)
                })
                .padding(24)
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            // add custom back button and share button
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
            }, trailing:
                Button(action: {
                    actionSheet()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            )
            // enable swipe back
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                if (value.startLocation.x < 20 && value.translation.width > 100) {
                    self.mode.wrappedValue.dismiss()
                }
            }))
        }
        .padding(0)
        .onAppear(){
            if !UserDefaults.standard.bool(forKey: "remove_ads") {
//                self.interstitial.showAd()
            }
        }
    }
    
    func actionSheet() {
        guard let data = URL(string: new.link) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(new: Post.default)
    }
}

