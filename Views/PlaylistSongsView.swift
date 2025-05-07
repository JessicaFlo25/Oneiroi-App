//
//  PlaylistSongsView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 5/6/25.
//

import SwiftUI

struct PlaylistSongsView: View {
    @EnvironmentObject var playlistController: DreamPlaylistController
    let dream:Dream
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let mockDream = Dream(
        description: "In my dream, I was on a beach made of stars.",
        title: "Galactic Shores",
        date: Date(),
        tags: ["Ambient", "Calm", "Wonder"],
        playlistID: "mock_playlist_123"
    )
    PlaylistSongsView(dream:mockDream)
}
