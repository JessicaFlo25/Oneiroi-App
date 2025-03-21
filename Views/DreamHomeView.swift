//
//  DreamHomeView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/16/25.
//
import SwiftUI

struct DreamHomeView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    //sets the background as dinosaur image, first bottom layer
                    Image("dinosaur")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 0.6
                        )
                        .offset(y: geometry.size.height * 0.3)
                        .ignoresSafeArea()
                    
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("What do you remember?")
                                .font(.custom("AnticDidone-Regular",
                                              size: geometry.size.width > 600 ? 34 : 28))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .padding(.leading)
                            
                            Spacer()
                            
                            NavigationLink(destination: AddDreamView()) {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 28, weight: .heavy))
                                    .scaledToFit()
                                    .scaleEffect(1.2)
                                    .foregroundColor(.blue)
                                    .padding(.trailing)
                            }
                        }
                        .frame(height: 90)
                        
                        Divider()
                            .background(Color.gray)
                            .frame(width: geometry.size.width)
                        //after this line can add 'folders' for the dreams
                        Spacer()
                    }
                    .frame(width: geometry.size.width, alignment: .top)
                }
            }
        }
    }
}



#Preview {
    DreamHomeView()
}
