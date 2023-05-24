//
//  CategoryNewsView.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import SwiftUI

struct CategoryNewsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    var category: Category
    
    @State var posts = [Post]()
    @State var page = 1
    @State var isLoading = false
    
    
    var body: some View {
        List{
            ForEach (posts) { row in
                NavigationLink(destination: PostView(new: row)) {
                    PostRowView(post: row)
                }
            }
            HStack {
                Image(systemName: "arrow.down")
                Text("Scroll to new posts").font(.footnote)
                    .onAppear {
                        if !isLoading {
                            self.page = self.page + 1
                            loadData()
                        }
                        print("Reached end of scroll view")
                    }
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .navigationBarTitle(category.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        // add custom back button and share button
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
        }
        )
        // enable swipe back
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if (value.startLocation.x < 20 && value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
        .onAppear(){
            loadData()
        }
    }
    
    
    func loadData() {
        isLoading = true
        guard let url = URL(string: "\(URL_CATEGORY_POST)\(category.id)&page=\(page)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        isLoading = false
                        self.posts.append(contentsOf: decodedResponse)
                        //                            self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}

struct CategoryNewsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryNewsView(category: Category.default)
    }
}
