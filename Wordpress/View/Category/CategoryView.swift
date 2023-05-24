//
//  CategoryView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @State var categories = [Category]()
    @Binding var showMenu : Bool
    var body: some View {
        NavigationView {
            List(mainViewModel.categories) { row in
                NavigationLink(destination: CategoryNewsView(category: row)) {
                    CategoryRowView(category: row)
                }
            }.listStyle(PlainListStyle())
            .navigationBarTitle(LocalizedStringKey("Category"))
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation{
                            
                            self.showMenu.toggle()
                        }
                    }, label: {
                        
                        Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                            .font(.title2)
                    })
                }
            })
        }
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(categories: [Category.default], showMenu: .constant(false))
    }
}
