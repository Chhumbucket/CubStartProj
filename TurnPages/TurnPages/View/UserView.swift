//
//  UserView.swift
//  TurnPages
//
//  Created by Dylan Chhum on 4/19/24.
//

import SwiftUI

struct UserView: View {
    @State private var profileInfo: String = ""
    enum Tab {
        case books, reviews
    }
    
    @State private var selectedTab: Tab = .books
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.custom("Georgia", size: 50))
                .foregroundColor(Color(hex: "#6F4E37"))
                .padding(.top, 16)
            
            ZStack {
                Circle()
                    .fill(Color(hex: "#B7825F"))
                    .frame(width: 120, height: 120)
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .foregroundColor(Color(hex: "#774E32"))
            }
            
            Text("@username")
                .font(.custom("Georgia", size: 25))
                .foregroundColor(Color(hex: "#774E32"))
            
            NavigationView {
                TextEditor(text: $profileInfo)
                    .frame(minHeight: 25, maxHeight: 280)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 340)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 200, idealHeight: 300, maxHeight: .infinity)
                    .background(Color(hex: "#C0A891"))
                    .cornerRadius(10)
                    .padding()
                    .lineLimit(nil)
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
        .background(Color(hex: "#E3DCD5"))
        .navigationTitle("Profile")
        .font (
            .custom(
                "Menlo",
                fixedSize: 15))
            .foregroundColor(Color(hex: "#6F4E37"))
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
