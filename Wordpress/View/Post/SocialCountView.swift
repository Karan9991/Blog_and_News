//
//  SocialCountView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct SocialCountView: View {
    @State var showingDetail = false
    @State var isLiked = false
    @State var  comments = [Comment]()
    var new:Post!
    var likeButtonColor: Color {
        return isLiked ? Color.red.opacity(0.6) : Color("customBlack")
    }
    var likeButtonText: String {
        return isLiked ? "Liked" : "Like"
    }
    var body: some View {
        HStack(spacing: 24){
            Button(action: {
                self.showingDetail.toggle()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "message.fill").frame(width: 24, height: 24).foregroundColor(Color.blue.opacity(0.6))
                    Text("\(comments.count) " + "Comments").font(.subheadline).foregroundColor(Color("customBlack"))
                }
            }
            .sheet(isPresented: $showingDetail) {
                CommentsView(post: self.new)
            }
            Button(action: {
                isLiked.toggle()
                if isLiked {
                    UserDefaultsManager.save(new)
                }else {
                    UserDefaultsManager.remove(new)
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.red.opacity(0.6))
                    Text(likeButtonText).font(.subheadline).foregroundColor(likeButtonColor)
                }
            }
        }
        .onAppear(){
            loadData()
            isLiked = UserDefaultsManager.isInclude(new.id)
        }
    }
    
    func loadData() {
        guard let url = URL(string: "\(URL_POST_COMMENTS)\(new.id)") else {
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

struct newalCountView_Previews: PreviewProvider {
    static var previews: some View {
        SocialCountView()
    }
}

