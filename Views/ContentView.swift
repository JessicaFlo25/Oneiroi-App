//
//  ContentView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/2/25.
//

import SwiftUI
import GoogleGenerativeAI
import SwiftData

struct ContentView: View {
    @ObservedObject var playlistController = DreamPlaylistController()
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        //in order to set the accesstoken need to attach it to a view since can not attach to conditionals because of type never
        Group {
            if playlistController.wasAuthenticated {
                NavigationStack {
                    DreamHomeView()
                }
            } else {
                WelcomeView(playlistController: playlistController)
            }
        }
        .onOpenURL { url in
            playlistController.updateAccessToken(url)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dream.self, configurations: config)
    
    return ContentView(playlistController: DreamPlaylistController())
        .modelContainer(container)
}
