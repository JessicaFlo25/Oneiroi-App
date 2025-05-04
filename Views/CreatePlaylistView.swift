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
    
    var body: some View {
        Button(action: {
             viewModel.createPlaylist(for: dream)
        }) {
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Creating...")
                }
            } else if dream.playlistWasCreated {
                Label("Open Playlist", systemImage: "music.note.list")
            } else {
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
            do {
                let user: spotifyUserID = try await viewModel.retrieveUserID(accessToken: playlistController.accessToken!)
                displayedUserID = user.id // Access the id property
                displayedUserID = user.id //Store the ID
            }catch {
                print("Error fetching user ID:", error)
            }
        }
    }
}

#Preview {
    //create a sample dream for preview
    let sampleDream = Dream(
        description: "I was flying over mountains made of candy",
        title: "Sweet Adventure",
        date: Date(),
        tags: ["Electronic", "Euphoria", "Freedom"]
    )
    
    CreatePlaylistView(dream: sampleDream)
        .modelContainer(for: Dream.self) 
}
