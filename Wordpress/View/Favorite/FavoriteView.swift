//
//  FavoriteView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State var posts = [Post]()
    @Binding var showMenu : Bool
    var body: some View {
        
        NavigationView {
            List{
                ForEach (posts) { row in
                    NavigationLink(destination: PostView(new: row)) {
                        PostRowView(post: row)
                    }
                }
            }.listStyle(PlainListStyle())
            .navigationBarTitle(LocalizedStringKey("Favorite"))
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
        .onAppear(){
            posts = UserDefaultsManager.load()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(showMenu: .constant(false))
    }
}
