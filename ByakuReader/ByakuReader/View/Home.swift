//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Home: View {
    
    @Binding var authFlow: AuthViewManager
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : User
    @State var searchText : String = ""
    
    private let title = [
        "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria"
    ]
    
    private var searchResults : [String] {
        searchText.isEmpty ? title : title.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                Text("hi")
                
            } // VStack
            .searchable(text: $searchText)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        
                    } label: {
                        Image(systemName: "gear")
                    } // button
                }// toolbar item 1
                
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        
                    } label: {
                        Image(systemName: "person")
                            .frame(width: 40, height: 40)
                    }
                }// toolbar item 2
            }// tool bar
        } // navigation stack
    } // body
} // home

#Preview {
    Home(authFlow:.constant(.home)).environmentObject(User())
}
