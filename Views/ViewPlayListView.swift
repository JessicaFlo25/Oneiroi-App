//
//  ViewPlayListView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/27/25.
//
import SwiftUI

struct ViewPlayListView: View {
    let playlistID: String
    
    var body: some View {
        VStack {
            Text("Playlist ID: \(playlistID)")
                .font(.title)
        }
        .navigationTitle("Your Dream Playlist")
    }
}
