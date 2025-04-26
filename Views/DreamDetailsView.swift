//
//  DreamDetailsView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/25/25.
//

import SwiftUI

struct DreamDetailView: View {
    let dream: Dream
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(dream.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(dream.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                
                Text(dream.dreamDescription)
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
