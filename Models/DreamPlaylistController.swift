//
//  DreamPlaylistController.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/23/25.
//

import SwiftUI
import SpotifyiOS
import Combine

//this class is responsible for user authentication after gemini response
//does not include methods pertaining to playlist creation, etc.,
class DreamPlaylistController: NSObject, ObservableObject, SPTAppRemoteDelegate {
    //standard required methods for usage:
    //use to check if connection was successful, because then will be able to make calls
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("A connection has been established with the app remote")
    }
    //method to check for failed connction
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: (any Error)?) {
        print("Spotify app remote connection failed: \(error?.localizedDescription ?? "unknown error")")
    }
    //use when the connection stops for any reason e.g., activity,manual disconnect etc.,
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: (any Error)?) {
        print("Spotifu app remote was disconnected: \(error?.localizedDescription ?? "unknown error")")
    }
    //hold access token
    @Published var accessToken: String?
    @Published var wasAuthenticated: Bool = false
    
    //from spotify documentation
    let spotifyClientID = "02fbf9c2a8b3433cb701048822c6beda"
    let spotifyRedirectURL = URL(string:"spotify-ios-quick-start://spotify-login-callback")!
    //main entry point for interacting with spotify
    lazy var appRemote: SPTAppRemote = {
          let appRemote = SPTAppRemote(configuration: SPTConfiguration(
            clientID: spotifyClientID,
            redirectURL: spotifyRedirectURL
          ), logLevel: .debug)
          appRemote.delegate = self
          return appRemote
      }()
    
    //while can open Spotify app to obtain access token within viewmodel, I prefered to include it within this class
    func authorizeandOpenApp() {
        //define scopes (aka permisions) to use certain endpoints since not included at authorization; "extra authorizations"
        let scopes: [String] = [
            "playlist-modify-public", //to make playlist & add songs
            "playlist-modify-private",//to make playlist & add songs
            "user-read-private", //needed to retrieve user information
            "user-read-email"//needed to retrieve user information
        ]
        
        appRemote.authorizeAndPlayURI("", asRadio: false, additionalScopes: scopes)
    }
    
    //
    func updateAccessToken(_ url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            self.wasAuthenticated.toggle()
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("There was an error with authentication: \(errorDescription)")
            
        }
    }
    
}

