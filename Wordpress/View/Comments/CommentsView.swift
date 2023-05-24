//
//  CommentsView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Kingfisher

struct CommentsView: View {
    @StateObject var commentCreation = CommentCreationViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var post: Post
    @State var  comments = [Comment]()
    @State var showComment = false
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if showComment {
                    NewCommentView(postId:post.id, showComment: $showComment).environmentObject(commentCreation)
                }
                
                ForEach (comments) { comment in
                    CommentView(comment: comment)
                }
            }
            .navigationBarTitle("Comments")
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark")
            },trailing: Button(action : {
                self.showComment.toggle()
            }){
                Image(systemName: "plus.message")
            })
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "\(URL_POST_COMMENTS)\(post.id)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Comment].self, from: data) {
                    DispatchQueue.main.async {
                        self.comments = decodedResponse
                        //                            self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}



struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(post: Post.default)
    }
}

