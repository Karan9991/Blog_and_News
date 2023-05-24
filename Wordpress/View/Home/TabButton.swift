//
//  TabButton.swift
//  News
//
//  Created by Asil Arslan on 26.12.2020.
//

import SwiftUI

struct TabButton: View {
    var category : Category
    @Binding var selectedCategory : Category
    var animation : Namespace.ID
    var onTabChanged : ((Category) -> Void)?
    
    var body: some View {
        
        Button(action: {
            
            withAnimation(.spring()){selectedCategory = category}
            
            onTabChanged!(selectedCategory)
            
        }, label: {
            
            VStack(alignment: .leading, spacing: 6, content: {
                
                Text(category.name.decodingHTMLEntities())
                    .fontWeight(.heavy)
                    .foregroundColor(selectedCategory.name == category.name ? Color("customBlack") : .gray)
                    .multilineTextAlignment(.leading)
                
                // adding animation...
                
                if selectedCategory.name == category.name{
                    Capsule()
                        .fill(Color("customBlack"))
                        .frame(width: 40, height: 4)
                        .matchedGeometryEffect(id: "Tab", in: animation)
                }
            })
            // default width...
            .frame(width: 100)
        })
    }
    
    
}

extension TabButton {
  
  public func onTabChanged(_ action: @escaping ((Category) -> Void)) -> Self {
    var copy = self
    copy.onTabChanged = action
    return copy
  }
}
