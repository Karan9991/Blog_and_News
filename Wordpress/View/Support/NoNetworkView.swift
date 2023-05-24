//
//  NoNetworkView.swift
//  Wordpress
//
//  Created by Asil Arslan on 20.08.2021.
//

import SwiftUI

struct NoNetworkView: View {
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                
                Spacer()
                
                Image(systemName: "wifi.slash")
                    .font(.system(size: 70))
                Text("Not Connected")
                    .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetworkView()
    }
}
