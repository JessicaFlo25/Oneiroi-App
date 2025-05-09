//
//  OneiroiApp.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/2/25.
//

import SwiftUI
import SwiftData

@main
struct OneiroiApp: App {
    @StateObject var playlistController = DreamPlaylistController()
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(playlistController)
            .preferredColorScheme(.light)  //ensure app is in light mode becuase of png drawings
        }
        //ensures that all views have access to same created model context
        .modelContainer(for: Dream.self)
    }
}
