//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("Hi")
            } // VStack
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
    Home()
}
