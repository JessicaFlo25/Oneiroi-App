//
//  PlaylistSongsView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 5/6/25.
//

import SwiftUI

struct PlaylistSongsView: View {
    @EnvironmentObject var playlistController: DreamPlaylistController
    @StateObject var viewModel = PlaylistSongsViewModel()
    @State private var songs: [tracksObject] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    let dream:Dream
    
    var body: some View {
        VStack {
            List(songs, id: \.id) { track in
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: track.album.images.first?.url ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(6)
                    
                    VStack(alignment: .leading) {
                        Text(track.name)
                            .font(.custom("AnticDidone-Regular", size: 18))
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(track.artists.first?.name ?? "Unknown Artist")
                            .font(.custom("AnticDidone-Regular", size: 18))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("\(dream.title) Playlist")
        .task {
            guard let accessToken = playlistController.accessToken else {
                errorMessage = "Missing access token"
                return
            }
            
            do {
                let result = try await viewModel.retrievePlaylistSongs(for: dream, accessToken: accessToken)
                songs = result.items.map { $0.track }
                isLoading = false
            } catch {
                errorMessage = "Failed to load songs: \(error.localizedDescription)"
                isLoading = false
            }
        }
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
    
    let controller = DreamPlaylistController()
    controller.accessToken = "mock_token"
    
    return PlaylistSongsView(dream: mockDream)
        .environmentObject(controller)
}
