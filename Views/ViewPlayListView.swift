//
//  ViewPlayListView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/27/25.
//
import SwiftUI
import SwiftData

struct ViewPlayListView: View {
    let dream:Dream
    let userID:String
    @EnvironmentObject var playlistController: DreamPlaylistController
    @StateObject private var viewModel = ViewPlaylistViewModel()
    @State private var tracks: [tracksObject] = [] //holds tracks we found provided by our method called
    @State private var isLoading = true
    @State private var errorMessage: String?
    var body: some View {
        VStack {
//            Text("Playlist ID: \(dream.playlistID!)")
//                .font(.title)//at this point should have this

            if isLoading {
                ProgressView("Loading Tracks...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                List(tracks, id: \.uri) { track in
                    VStack(alignment: .leading) {
                        Text(track.name)
                        Text(track.uri).font(.caption).foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Your Dream Playlist")
        .task {
            guard let accessToken = playlistController.accessToken else {
                errorMessage = "No access token available"
                return
            }

            do {
                let result = try await viewModel.f(for: dream, accessToken: accessToken)
                tracks = result.tracks.items
                isLoading = false
            } catch {
                errorMessage = "Failed to fetch tracks: \(error)"
                isLoading = false
            }
        }

    }
}

#Preview {
    // Create a mock dream with a sample playlist ID
    let mockDream = Dream(
        description: "In my dream, I was on a beach made of stars.",
        title: "Galactic Shores",
        date: Date(),
        tags: ["Ambient", "Calm", "Wonder"],
        playlistID: "mock_playlist_123"
    )
    
    // Set up a model container in memory for the preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dream.self, configurations: config)
    
    return ViewPlayListView(dream: mockDream, userID: "mock_user_id_456")
        .modelContainer(container)
}

