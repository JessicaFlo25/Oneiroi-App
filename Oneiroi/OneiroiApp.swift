//
//  OneiroiApp.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/2/25.
//

import SwiftUI

@main
struct OneiroiApp: App {
    @StateObject var spotifyController = SpotifyController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    spotifyController.setAccessToken(from: url)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
                    spotifyController.connect()
                })
        }
    }
}
