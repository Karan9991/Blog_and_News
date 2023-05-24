//
//  SettingView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    @StateObject var storeManager: StoreManager
    @Binding var showMenu : Bool
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    
                    GroupBox(label:SettingsLabelView(labelText: "News", labelImage: "info.circle")){
                        
                        Divider().padding(.vertical, 4)
                        
                        HStack(alignment:.top, spacing: 10) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(9)
                            Text(LocalizedStringKey("Info Description"))
                                .font(.footnote)
                            Spacer()
                        }
                    }
                    
                    GroupBox(label : SettingsLabelView(labelText: "Premium", labelImage: "suit.diamond")){
//                        SimulatorStoreView()
                        ForEach(storeManager.myProducts, id: \.self) { product in
                            Divider().padding(.vertical, 4)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.localizedTitle)
                                        .font(.headline)
                                    Text(product.localizedDescription)
                                        .font(.caption2)
                                }
                                Spacer()
                                if UserDefaults.standard.bool(forKey: product.productIdentifier) {
                                    Text(LocalizedStringKey("Purchased"))
                                        .foregroundColor(.green)
                                } else {
                                    Button(action: {
                                        storeManager.purchaseProduct(product: product)
                                    }) {
                                        Text("Buy for \(product.price) $")
                                    }
                                    .foregroundColor(.blue)
                                }
                            }.padding(.vertical, 4)
                        }
                    }
                    
                    GroupBox(label : SettingsLabelView(labelText: "Customization", labelImage: "paintbrush")){
                        
                        Divider().padding(.vertical, 4)
                        Text("If you wish, you can restart the application by toggle the switch in this box. That way it starts the onboarding process and you will see the welcome screen again.")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        
                        Toggle(isOn: $isOnboarding){
                            if isOnboarding {
                                Text("Restart".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Restart".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                    }
                    
                    GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")){
                        
                        SettingsRowView(name: "Developer",content: DEVELOPER)
                        SettingsRowView(name: "Compability",content: COMPABILITY)
                        SettingsRowView(name: "Website", linkLabel: WEBSITE_LABEL, linkDestination: WEBSITE_LINK)
                        SettingsRowView(name: "Version",content: VERSION)
                        
                    }
                    
                }
                .navigationBarTitle(Text(LocalizedStringKey("Setting")), displayMode: .large)
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            storeManager.restoreProducts()
                        }) {
                            Text("Restore Purchases")
                        }
                    }
                })
                .padding()
            }//: ScrollView
            
        }//: NavigationView
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SimulatorStoreView: View {
    var body: some View {
        VStack {
        Divider().padding(.vertical, 4)
            HStack {
                VStack(alignment: .leading) {
                    Text("Donate")
                        .font(.headline)
                    Text("Donate App")
                        .font(.caption2)
                }
                Spacer()
                if UserDefaults.standard.bool(forKey: "*ID of IAP Product*") {
                    Text("Purchased")
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        //Purchase particular IAO product
                    }) {
                        Text("Buy for 5.09 $")
                    }
                    .foregroundColor(.blue)
                }
            }
        Divider().padding(.vertical, 4)
            HStack {
                VStack(alignment: .leading) {
                    Text("Remove Ads")
                        .font(.headline)
                    Text("Remove All Ads")
                        .font(.caption2)
                }
                Spacer()
                if UserDefaults.standard.bool(forKey: "*ID of IAP Product*") {
                    Text("Purchased")
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        //Purchase particular IAO product
                    }) {
                        Text("Buy for 1.09 $")
                    }
                    .foregroundColor(.blue)
                }
            }
        }.padding(.vertical, 4)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(storeManager: StoreManager(), showMenu: .constant(false))
    }
}
