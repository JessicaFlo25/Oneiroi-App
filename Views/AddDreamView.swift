//
//  AddDreamView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/18/25.
//

import SwiftUI

struct AddDreamView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var addDreamViewModel = AddDreamViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("Stork")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.6
                    )
                    .offset(y: geometry.size.height * 0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Title Section
                    HStack {
                        TextField("Dream Title...", text: $addDreamViewModel.title, axis: .vertical)
                            .disableAutocorrection(true)
                            .font(.custom("AnticDidone-Regular",
                                      size: geometry.size.width > 600 ? 28 : 30))
                            .textFieldStyle(.plain)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .padding(.leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 3)
                                    .frame(height: 70)
                            )
                            .padding(.horizontal)
                        Spacer()
                    }
                    .frame(height: 100)
                    
                    Divider()
                        .background(Color.black)
                        .frame(width: geometry.size.width)
                        .padding(.bottom, 20)
                    
                    // Description Section with Auto-Scrolling
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            TextField("Dream description...",
                                    text: $addDreamViewModel.dreamDescription,
                                    axis: .vertical)
                                .disableAutocorrection(true)
                                .font(.custom("AnticDidone-Regular",
                                            size: geometry.size.width > 600 ? 20 : 21))
                                .textFieldStyle(.plain)
                                .fontWeight(.bold)
                                .lineLimit(4...)
                                .minimumScaleFactor(0.7)
                                .padding(.leading)
                                .id("textField")
                            
                            // Invisible spacer for scroll target
                            Color.clear
                                .frame(height: 1)
                                .id("bottomSpacer")
                        }
                        .onChange(of: addDreamViewModel.dreamDescription) {
                            withAnimation {
                                scrollProxy.scrollTo("bottomSpacer", anchor: .bottom)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 3)
                                .frame(height: 350)
                        )
                        .padding(.horizontal)
                        .frame(height: 350)
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        print("Submitting dream...")
                        // Add your save logic here
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width, alignment: .top)
            }
        }
    }
}

#Preview {
    AddDreamView()
}
