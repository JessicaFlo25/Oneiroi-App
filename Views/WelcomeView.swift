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
                //first "layer" is the angel (bottom)
                    Image("angel") // Center Image
                        .resizable()
                        .frame(width: 400, height:500)
                        .padding(.bottom, 20)
                //layer on top
                VStack(spacing: 5) {
                    Text("ONEIROI") // Title above the image
                        .font(.custom("AnticDidone-Regular", size: 34))
                        .fontWeight(.bold)
                        .padding(.bottom, 90)
                        .foregroundColor(.black)
                        .padding(.top,40)
                    VStack{
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
}

#Preview {
    WelcomeView()
}
