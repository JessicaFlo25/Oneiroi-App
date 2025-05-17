//
//  ViewPlaylistViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 5/5/25.
//

import Foundation
import Combine

class ViewPlaylistViewModel:ObservableObject {
    // MARK: -This function searches items
    ///Takes in access token and dream
    func searchForSongs(for dream: Dream,accessToken:String) async throws -> returnedTracks {
        ///These are what we are going to pass to build our query
        //first grab the first tag(index 0) in tags array since this is the genre
        let genreTag = dream.tags[0]
        let limit = 5
        let offset = 0
        
        let endpoint = "https://api.spotify.com/v1/search"
        //convert to url object, will be mutated later when attaching querie
        var urlComponents = URLComponents(string: endpoint)!
        //build up the query whch involves the genre and track limit,etc.,
        urlComponents.queryItems = [
            //based off docs match the key and provide values for the scope of project
            URLQueryItem(name:"q",value:"genre:\(genreTag)"),
            URLQueryItem(name:"type",value:"track"),
            URLQueryItem(name:"limit",value:String((limit))), //esnure these two are strings
            URLQueryItem(name:"offset",value:String(offset))
        ]
        
        guard let url = urlComponents.url else {
            throw spotifyErrorDetails.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else {
            throw spotifyErrorDetails.invalidresponse
        }
        
        let decoded = try JSONDecoder().decode(returnedTracks.self, from: data)
        //since we declared our return type to be returned tracks we can get items only through dot notation
        return decoded
    }
    //downside to provided search endpoint is that the same song will be a single but then released as part of an album
    //there is no current way to do this as the documentation doesn't provide any methods or ways to prevent repeats,
    //thi is moreso done in the actual backend where I would map through the returned response and perform checks
    
    // MARK: -This method will 'insert' our curent songs into the existing playlist of the user for the current dream
    /// Requires: access token, and dream (playlist ID which we already have by the point of searching for songs, and array of URIs from saved returnedTracks Object
    /// NOTE SUCCESS STATUS CODE IS 201
    func insertSongsIntoPlaylist(accessToken: String, for dream: Dream, trackURIs:[String]) async throws {
        //using the saved playlist id from passed dream
        //because playlist ID is an optional value, need toa ddress force unwrapping an optional value
        guard let playlistID = dream.playlistID else {
            throw spotifyErrorDetails.invalidURL
        }
        //can now safely use the playlistid value
        let endpoint = "https://api.spotify.com/v1/playlists/\(playlistID)/tracks"
        //ensure is url object
        guard let url = URL(string: endpoint) else {
            throw spotifyErrorDetails.invalidURL
        }
        //define request as POST, since will be adding to playlist
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //structure body request using struct in model
        let playlistSongsRequest = addTracksToPlaylistRequestBody(
            uris: trackURIs
        )
        //attach
        request.httpBody = try JSONEncoder().encode(playlistSongsRequest)
        //do not have to use data in this case since all change are made on already exsiting playlist, so no need
        let (_,response) = try await URLSession.shared.data(for: request)
        //success error is 201
        guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 201 else {
            throw spotifyErrorDetails.invalidresponse
        }
    }
}
