//
//  HeaderView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct HeaderView: View {
    let text: String
    var body: some View {
        HStack {
            Text(LocalizedStringKey(text)).font(.headline).padding(EdgeInsets(top: 24, leading: 28, bottom: 24, trailing: 24))
        }
        .frame(width: UIScreen.main.bounds.width, height: 36, alignment: .leading)
        .background(Color(UIColor.systemBackground))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(text: "Lorem Ipsum")
    }
}
