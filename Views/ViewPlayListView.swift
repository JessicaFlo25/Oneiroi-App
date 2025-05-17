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
    //this is required, because up to this point dream is not availble which is why app storage is a basic string for now
    var songsInsertedKey: String {
        "songsInserted-\(dream.id.uuidString)"
    }
    //because task will be ran every time navigate to viewplaylist, insertion will reoocur every time, boolean value will never truly persist
    @AppStorage("songsInserted-default") private var songsWereInserted: Bool = false
    var body: some View {
        VStack {
            //            Text("Playlist ID: \(dream.playlistID!)")
            //                .font(.title)//at this point should have this
            if isLoading {
                ProgressView("Loading Tracks...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            else {
                //will call seperate view to display thw playlist items
                //the user will never see the results of the search but rather finalized playlist
                PlaylistSongsView(dream: dream)
            }
        }
        .task {
            guard let accessToken = playlistController.accessToken else {
                errorMessage = "No access token available"
                return
            }
            
            do {
                let result = try await viewModel.searchForSongs(for: dream, accessToken: accessToken)
                tracks = result.tracks.items ///will be used to pass to to insertsongsintoplaylist
                // check that the insertion has happened already
                let key = songsInsertedKey
                //rather than simple boolean working with appstorage allows boolean value to trul persist; whereas a simple state boolean would never reamin "true" becasue the task would rerun and make api call every time view reloads
                if !UserDefaults.standard.bool(forKey: key) {
                    //access uris and map them into an array
                    let uris = result.tracks.items.map{$0.uri}
                    try await viewModel.insertSongsIntoPlaylist(accessToken: accessToken, for: dream, trackURIs: uris)
                    UserDefaults.standard.set(true, forKey: key)
                }
                
                isLoading = false
            } catch {
                errorMessage = "Failed to fetch tracks: \(error)"
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dream.self, configurations: config)
    //ensure envrinment variables are present
    return ViewPlayListView(dream: mockDream, userID: "mock_user_id_456")
        .modelContainer(container)
        .environmentObject(DreamPlaylistController())
}

