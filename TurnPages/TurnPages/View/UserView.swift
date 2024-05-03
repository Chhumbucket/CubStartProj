//
//  UserView.swift
//  TurnPages
//
//  Created by Dylan Chhum on 4/19/24.
//

import SwiftUI

struct UserView: View {
    enum Tab {
        case books, reviews
    }
    
    @State private var selectedTab: Tab = .books
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack {
            Picker(selection: $selectedTab, label: Text("Tab")) {
                Text("Books").tag(Tab.books)
                Text("Reviews").tag(Tab.reviews)
            }
            
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
            
            NavigationView {
                List{
                    NavigationLink(destination: UserActivity()) {
                        Text("Film")
                    }
                    Text("Hi")
                    
                }
            }
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "house")
                    Text("Main Menu")
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    // Profile Action
                }) {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    // Search Action
                }) {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .padding()
            }
            .background(Color.gray.opacity(0.2))
            
        }
    }
}

struct UserActivity: View {
    var body: some View {
        Text("VIew")
    }
    
}

#Preview {
    UserView(isPresented: .constant(false))
}
