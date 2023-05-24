//
//  NewCommentView.swift
//  News
//
//  Created by Asil Arslan on 27.12.2020.
//

import SwiftUI

struct NewCommentView: View {
    @EnvironmentObject var commentCreation : CommentCreationViewModel
    @State var postId:Int = 0
    @Binding var showComment : Bool
    
    var body: some View {
        VStack{
            
            HStack(spacing: 15){
                
                Image(systemName: "person.fill")
                    .foregroundColor(.accentColor)
                
                TextField("Name", text: $commentCreation.name)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(Color("ColorWhite"))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            .padding(.vertical)
            
            HStack(spacing: 15){
                
                Image(systemName: "envelope.fill")
                    .foregroundColor(.accentColor)
                
                TextField("Email", text: $commentCreation.email).keyboardType(.emailAddress)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(Color("ColorWhite"))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            
            TextEditor(text: $commentCreation.comment)
                .frame(height: 200)
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color("ColorWhite"))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding(.vertical)
            
            Button(action: {
                commentCreation.sendComment()
                showComment.toggle()
            }, label: {
                
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    Text("Send Comment")
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "paperplane.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color.accentColor)
                .cornerRadius(8)
            })
            // disabling Button....
            .opacity((commentCreation.name != "" && commentCreation.email != "" && commentCreation.comment != "" ) ? 1 : 0.6)
            .disabled((commentCreation.name != "" && commentCreation.email != "" && commentCreation.comment != "") ? false : true)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .onAppear(perform: {
            commentCreation.postId = postId
            commentCreation.name = ""
            commentCreation.email = ""
            commentCreation.comment = ""
        })
    }
}

struct NewCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NewCommentView(showComment: .constant(false)).environmentObject(CommentCreationViewModel())
            .previewLayout(.sizeThatFits)
    }
}


class CommentCreationViewModel: NSObject,ObservableObject{
    
    @Published var postId:Int = 0
    // User Details...
    @Published var name = ""
    @Published var email = ""
    @Published var comment = ""
    
    func sendComment(){
        
        
        name = name.replacingOccurrences(of: " ", with: "%20")
        
        // Prepare URL
        let url = URL(string: URL_COMMENTS)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "post=\(postId)&author_name=\(name)&author_email=\(email)&content=\(comment)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
    
}
