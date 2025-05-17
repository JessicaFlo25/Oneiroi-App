//
//  PlaylistSongsViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 5/7/25.
//

import Foundation

class PlaylistSongsViewModel:ObservableObject {
    
    //MARK: -This method simply fetches the songs from the playlist using playlist id of the dream
    func retrievePlaylistSongs(for dream: Dream, accessToken:String) async throws-> getPlaylistResponse{
        let limit = 5
        let offset = 0
        //while at this point should have the playlist ID cant force unwrapping to nil
        guard let playlistID = dream.playlistID else {
            throw spotifyErrorDetails.invalidURL
        }
        
        let endpoint = "https://api.spotify.com/v1/playlists/\(playlistID)/tracks"
        var urlComponents = URLComponents(string: endpoint)!
        
        //build up the query whch involves the genre and track limit,etc.,
        urlComponents.queryItems = [
            //based off docs match the key and provide values for the scope of project
            URLQueryItem(name:"limit",value:String((limit))), //esnure these two are strings
            URLQueryItem(name:"offset",value:String(offset))
        ]
        
        guard let url = urlComponents.url else {
            throw spotifyErrorDetails.invalidURL
        }
        //since this is a get request, no need to attadth the HTTP method
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  //it is a get
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        //recieve the response and the data
        let (data,response) = try await URLSession.shared.data(for: request)
        //ensure to get a successful response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw spotifyErrorDetails.invalidresponse
        }
        
        let decoded = try JSONDecoder().decode(getPlaylistResponse.self, from: data)
        //since we declared our return type to be returned tracks we can get items only through dot notation
        return decoded
    }
}

