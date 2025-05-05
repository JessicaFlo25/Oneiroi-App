//
//  CreatePlaylistView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/27/25.
//

import SwiftUI

//in unison with its viewmodel with cotain logic to crete the playlist and the call
//viewplaylist view
struct CreatePlaylistView: View {
    @EnvironmentObject var playlistController: DreamPlaylistController
    @StateObject private var viewModel = CreatePlaylistViewModel()
    @Bindable var dream: Dream
    @State private var displayedUserID: String = ""
    @State private var playlistid: String = ""
    @State private var navigateToTracks:Bool = false
    
    var body: some View {
        Button(action: {
            Task {
                //blocks edge case of repetitve generation of same playlist
                guard dream.playlistID == nil else{
                    print("playlist was already created. Check Spotify and look for a playlist with the name the same as this dream.")
                    return
                }
                viewModel.isLoading = true
                defer { viewModel.isLoading = false }
                do {
                    let playlist = try await viewModel.createPlaylist(for: dream, accessToken: playlistController.accessToken!)
                    dream.playlistID = playlist.id //once this value is assigned, it means that the playlist was created will be 'true'
                    // Optionally save dream here
                    playlistid = playlist.id
                    navigateToTracks = true
                    print("success at creating the playlist")
                } catch {
                    print("❌ Failed to create playlist:", error)
                }
            }
        }) {
            //if performing creation of playlist display loading
            //in fucntion call will toggle value of isLoading
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Creating...")
                }
            }
            //only need this check since conditonal for naviagtionlink already leads to viewplaylistview; another screen
            else if !dream.playlistWasCreated {
                VStack {
                    Label("Create Playlist", systemImage: "plus.circle")
                    Text(displayedUserID) // Display the ID here
                        .font(.caption)
                }
            }
        }
        .disabled(viewModel.isLoading)
        .animation(.default, value: viewModel.isLoading)
        .task {
            //only make call to fetch ID on first press EVER with access token
            if playlistController.accessToken != nil && viewModel.currentUserID == nil {
                do {
                    let user: spotifyUserID = try await viewModel.retrieveUserID(accessToken: playlistController.accessToken!)
                    viewModel.currentUserID = user.id //assign the fetched ID to avoid repetitve calls
                    displayedUserID = user.id //Store the ID
                }catch {
                    print("Error fetching user ID:", error)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToTracks) {
            if let userID = viewModel.currentUserID {
                ViewPlayListView(dream: dream, userID: userID)
            } else {
                Text("User ID not available")
            }
        }
        if dream.playlistWasCreated, let userID = viewModel.currentUserID {
            NavigationLink(destination: ViewPlayListView(dream: dream, userID: userID)) {
                Label("View Playlist", systemImage: "music.note")
            }
        }
    }
}

#Preview {
    let sampleDream = Dream(
        description: "I was flying over mountains made of candy",
        title: "Sweet Adventure",
        date: Date(),
        tags: ["Electronic", "Euphoria", "Freedom"]
    )
    
    let mockController = DreamPlaylistController()
    mockController.accessToken = "mock_token_here"
    
    return CreatePlaylistView(dream: sampleDream)
        .modelContainer(for: Dream.self)
        .environmentObject(mockController)
}
