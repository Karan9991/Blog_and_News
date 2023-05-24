//
//  PageView.swift
//  News
//
//  Created by Asil Arslan on 24.12.2020.
//

import SwiftUI

import SwiftUI
import Kingfisher

struct PageView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var webViewHeight: CGFloat = .zero
    @Binding var showPage : Bool
    
    let page: Page
    var body: some View {
        // use GeometryReader to get current frame
        NavigationView {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false, content: {
                if page._embedded?.featuredmedia != nil {
                    KFImage(source: .network(
                        page._embedded?.featuredmedia?.first?.source_url != "" ?
                            URL(string: (page._embedded?.featuredmedia?.first?.source_url)!)!
                            :
                            URL(string: EMPTY_IMAGE_URL)!
                    ))
                    .loadImmediately()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.width)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8.0, content: {
                    Text(page.title.rendered.decodingHTMLEntities()).font(.largeTitle)
                    Text(page.date.toDate())
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium, design: .default))
                    WebView(dynamicHeight: $webViewHeight,htmlContent: page.content.rendered)
                        .font(.subheadline)
                        .frame(height: webViewHeight)
                })
                .padding(24)
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            // add custom back button and share button
            .navigationBarItems(leading: Button(action : {
                self.showPage.toggle()
            }){
                Image(systemName: "xmark")
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
        }
    }
    
    func actionSheet() {
        guard let data = URL(string: page.link) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(showPage: .constant(false), page: Page.default)
    }
}

