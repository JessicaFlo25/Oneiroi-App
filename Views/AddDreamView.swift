//
//  AddDreamView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/18/25.
//

import SwiftUI
import SwiftData

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
                    
                    //display error messages, to reserve same amount of space for errors
                    let errorText: String = {
                        //both are invalid
                        if !titleErrorMessage.isEmpty && !dreamDescriptionErrorMessage.isEmpty {
                            return "\(titleErrorMessage)\n\(dreamDescriptionErrorMessage)"
                        } else if !titleErrorMessage.isEmpty {//title invalid so display saved error
                            return titleErrorMessage
                        } else if !dreamDescriptionErrorMessage.isEmpty {//description is invalid display saved error message
                            return dreamDescriptionErrorMessage
                        } else {//all were provided
                            return ""
                        }
                    }()

                    Text(errorText)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(height: errorText.isEmpty ? 0 : 50)
                        .animation(.easeInOut, value: errorText)

                    Button(action: {
                        //both valid
                        if addDreamViewModel.validateTitle() && addDreamViewModel.validateDescription() {
                            //all inputs were valid; change bool to true
                            addDreamViewModel.allValid.toggle()
                            //cretae instance of dream with saved provided values
                            let newDream = Dream(
                                description: addDreamViewModel.dreamDescription,
                                title: addDreamViewModel.title,
                                date: Date()
                            )
                            addDreamViewModel.currentDream = newDream
                            //perform insertion of the input
                            modelContext.insert(newDream)
                            //switfch boolean to true for navigation
                            addDreamViewModel.navigateToDreamAnalysis = true
                            //xplicitly save the context
                            do {
                                try modelContext.save()
                                print("Dream saved successfully!")
                            } catch {
                                print("Failed to save dream: \(error)")
                            }
                            

                            //print out all dreams inserted
                            addDreamViewModel.printSavedDreams(modelContext: modelContext)

                            //have to reset the message states because can be scenario where none or one isnt provided
                            //then at the next attempt, need to reset the message states to remove previous error messages
                            addDreamViewModel.title = ""
                            addDreamViewModel.dreamDescription = ""
                            titleErrorMessage = ""
                            dreamDescriptionErrorMessage = ""
                            //call gemini, using model logic
                            print(Date())
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
                            //speciic scenario where title invalid and dream description isn't
                            if !addDreamViewModel.validateTitle() && addDreamViewModel.validateDescription() {
                                titleErrorMessage = addDreamViewModel.titleErrorMessage
                                //description provided so reset the state to prevent showing previous state
                                dreamDescriptionErrorMessage = ""
                            }
                            //description was invalid but title was not so reset the state
                            else if !addDreamViewModel.validateDescription() && addDreamViewModel.validateTitle(){
                                dreamDescriptionErrorMessage = addDreamViewModel.dreamDescriptionErrorMessage
                                titleErrorMessage = ""
                            }
                        }
                    }) {
                        Text("Get Analysis!")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .navigationDestination(
                    isPresented: $addDreamViewModel.navigateToDreamAnalysis
                ) {
                    if let dream = addDreamViewModel.currentDream {
                        DreamAnalysisView(dream: dream)
                            .modelContext(modelContext)
                    }                }
                .frame(width: geometry.size.width, alignment: .top)
                //another check to ensuure context is correct
//                .onAppear {
//                    print("Context ID:", ObjectIdentifier(modelContext))
//                }
            }
        }
        .ignoresSafeArea(.keyboard, edges:.bottom)
        .gesture(
            TapGesture().onEnded { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )//inclued this since, assumed adding a button anywhere to dsimiss the keyboard would be invasive
    }
}
//in simulator keyboard may block submit button but there is a simple fix

//alter the preview since data may not persist in builds
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dream.self, configurations: config)
    
    return AddDreamView()
        .modelContainer(container)
}
