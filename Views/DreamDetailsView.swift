//
//  DreamDetailsView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/25/25.
//

import SwiftUI

struct DreamDetailView: View {
    @Bindable var dream: Dream
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(dream.title)
                        .font(.custom("AnticDidone-Regular",
                                      size: geometry.size.width > 600 ? 40 : 35))
                        .fontWeight(.bold)
                    if dream.tags.count == 3 {
                        //call resusuable view for tags
                        DreamTagView(dreamTags: $dream.tags)
                            .padding(.vertical, 5)
                    }
                    
                    Text(dream.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text(dream.dreamDescription)
                        .font(.custom("AnticDidone-Regular",
                                      size: geometry.size.width > 600 ? 40 : 25))
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Dream Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let dream = Dream(
        description: "There was this girl in my dream and she smiled at me and told me I was her muse. I did not know what this meant but when I went to reach for her hand she got farther and farther",
        title: "The Girl In My Dream",
        tags: ["Synthwave", "Anxiety", "Longing"]
    )
    return DreamDetailView(dream: dream)
}
