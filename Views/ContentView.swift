//
//  ContentView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/2/25.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
    @ObservedObject var spotifyController : SpotifyController
    var body: some View {
        VStack {
            WelcomeView(spotifyController: spotifyController)
                .onOpenURL { url in
                    spotifyController.setAccessToken(from: url)
                }
        }
        .padding()
        
    }
}

#Preview {
    ContentView(spotifyController: SpotifyController())
}
