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
    //hold error messgages from viewmodel and will be reset/checked in this view 
    @State private var titleErrorMessage: String = ""
    @State private var dreamDescriptionErrorMessage: String = ""

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
                    // Title
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
                                    .stroke(addDreamViewModel.titleErrorMessage.isEmpty ? Color.gray.opacity(0.5) : Color.red,
                                            lineWidth: 3
                                           )
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
                    //dream description
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
                                .stroke(addDreamViewModel.dreamDescriptionErrorMessage.isEmpty ? Color.gray.opacity(0.5) : Color.red , lineWidth: 3)
                                .frame(height: 300)
                        )
                        .padding(.horizontal)
                        .frame(height: 300)
                    }
                    .padding(.bottom, 30)
                    
                    //display error messages
                    //both are invalid
                    if !titleErrorMessage.isEmpty && !dreamDescriptionErrorMessage.isEmpty{
                        Text(titleErrorMessage + "\n" + dreamDescriptionErrorMessage)
                    }
                    else if !titleErrorMessage.isEmpty {
                        Text(titleErrorMessage)
                    }
                    else if !dreamDescriptionErrorMessage.isEmpty {
                        Text(dreamDescriptionErrorMessage)
                    }
                    
                    Button(action: {
                        //both valid
                        if addDreamViewModel.validateTitle() && addDreamViewModel.validateDescription() {
                            //have to reset the message states because can be scenario where none or one isnt provided
                            //then at the next attempt, need to reset the message states to remove previous error messages
                            titleErrorMessage = ""
                            dreamDescriptionErrorMessage = ""
                            //call gemini
                            print("yay they all provided")
                        }
                        else {
                            //both invalid
                            if !addDreamViewModel.validateTitle() && !addDreamViewModel.validateDescription(){
                                //error message for title
                                dreamDescriptionErrorMessage = addDreamViewModel.dreamDescriptionErrorMessage
                                //error message for description
                                titleErrorMessage = addDreamViewModel.titleErrorMessage
                            }
                            //title invalid
                            if !addDreamViewModel.validateTitle() && addDreamViewModel.validateDescription() {
                                titleErrorMessage = addDreamViewModel.titleErrorMessage
                                //description provided
                                dreamDescriptionErrorMessage = ""
                            }
                            //description was invalid
                            else if !addDreamViewModel.validateDescription() && addDreamViewModel.validateTitle(){
                                dreamDescriptionErrorMessage = addDreamViewModel.dreamDescriptionErrorMessage
                                titleErrorMessage = ""
                            }
                        }
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
