//
//  NavigationMenuView.swift
//  News
//
//  Created by Asil Arslan on 24.12.2020.
//

import SwiftUI

struct NavigationMenuView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @Binding var show : Bool
    @Binding var showPage : Bool
    @Binding var page : Page?
    
    var body: some View{
        
        //        ZStack{
        
        // Menu...
        
        HStack{
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Pages")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Divider()
                    .frame(width: 150, height: 1)
                    .background(Color.white)
                    .padding(.top, 10)
                
                
                
                
                ForEach(mainViewModel.pages) { item in
                    Button(action: {
                        
                        self.page = item
                        
                        withAnimation{
                            
                            self.show.toggle()
                            self.showPage.toggle()
                        }
                        
                    }) {
                        
                        Text(item.title.rendered.decodingHTMLEntities())
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .background(Color.clear)
                        .cornerRadius(10)
                    }
                }
                
 
                
                Spacer(minLength: 0)
            }
            .padding(.top,25)
            .padding(.horizontal,20)
            
            Spacer(minLength: 0)
        }
        .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)

        
    }

}

struct NavigationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenuView(show: .constant(false), showPage: .constant(false), page: .constant(nil))
    }
}
