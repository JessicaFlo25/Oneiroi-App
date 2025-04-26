//
//  WelcomeView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/8/25.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var playlistController =  DreamPlaylistController()
    //button to take to dreamhomebiew
    @State private var isPressed = false
    
    var body: some View {
            ZStack {
                Color.white
                
                // Corner Images
                VStack {
                    HStack {
                        Image("Flowers") // Top-left
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                        
                        Spacer()
                        
                        Image("Flowers") // Top-right
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    Spacer()
                    HStack {
                        Image("Flowers") // Bottom-left
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                        
                        Spacer()
                        
                        Image("Flowers") // Bottom-right
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                }
                
                // Main Content
                VStack(spacing: 20) {
                    Text("ONEIROI") // Title above the image
                        .font(.custom("AnticDidone-Regular", size: 34))
//                        .padding(.bottom, 10)
                    
                    Image("SpiderDream") // Center Image
                        .resizable()
                        .frame(width: 100, height:200)
                    
                    
                    Button(action:  {
                        isPressed.toggle()
                        playlistController.authorizeandOpenApp()
                    }) {
                        Text("Get Started")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
            }
        }
}

#Preview {
    WelcomeView()
}
