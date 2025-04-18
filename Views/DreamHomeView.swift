//
//  DreamHomeView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/16/25.
//
import SwiftUI
import SwiftData

struct DreamHomeView: View {
    @Environment(\.modelContext) private var modelContext
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
                            //consequences of not passing model context results in data not persitsing and seemingly disapperaing as if two'different' instances of app were open
                            //ensures submit will always add and show as 'added'
                            NavigationLink(destination: AddDreamView().modelContext(modelContext)
                            ) {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 28, weight: .heavy))
                                    .scaledToFit()
                                    .scaleEffect(1.2)
                                    .foregroundColor(.blue)
                                    .padding(.trailing)
                            }
                        }
                        .frame(height: 90)
                        //check that ID's are the same in console
//                        .onAppear {
//                            print("Context ID from home:", ObjectIdentifier(modelContext))
//                        }
                        
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dream.self, configurations: config)
    return DreamHomeView()
        .modelContainer(container)
}

