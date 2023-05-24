//
//  CategoryRowView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct CategoryRowView: View {
    
    let category:Category
    
    var body: some View {
        HStack {
            HStack {
                Text(category.name)
                    .fontWeight(.bold)
                    .padding(20)
                
                Spacer()
                
                Text("\(category.count)")
                    .fontWeight(.bold)
                    .frame(width: 50)
                    .padding(12)
                    .background(Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                    .padding(8)
            }
            .background(Color(.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            .padding(5)
        }
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(category: Category.default)
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
        CategoryRowView(category: Category.default2)
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
    }
}
