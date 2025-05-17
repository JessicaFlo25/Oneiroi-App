//
//  DreamTagView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/26/25.
//this view is intended to be used for the dispaly of dream tags

import SwiftUI

struct DreamTagView: View {
    @Binding var dreamTags: [String]
    var colors: [Color] = [.purple, .blue, .green]

    var body: some View {
        Group {
            //foreach rather than indexing to avoid repition
            if dreamTags.count == 3 {
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { index in
                        Text(dreamTags[index])
                            .font(.custom("AnticDidone-Regular", size: 15))
                            .font(.subheadline)
                            .lineLimit(2)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(colors[index].opacity(0.2))
                            .foregroundColor(colors[index])
                            .cornerRadius(15)
                    }
                }
            }
        }
    }
}

#Preview {
    // Preview wrapper since we need binding
    struct PreviewWrapper: View {
        @State var tags = ["Synthwave", "Anxiety", "Longing"]
        
        var body: some View {
            DreamTagView(dreamTags: $tags)
        }
    }
    return PreviewWrapper()
}
