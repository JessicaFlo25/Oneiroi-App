//
//  CreatePlaylistViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/27/25.
//

import Foundation
//will hold logic pertaining to calling methods within this view
//but rely on defined structs from spotify api defined in createplaylistmodel to hold responses
//
class CreatePlaylistViewModel:ObservableObject {
    @Published var isLoading: Bool = false
    @Published var currentUserID: String? //for debuggin purposes
    
    // MARK: UserID retrieval of current user
    //responsible for grabbing the user ID from provuded endpoint, first step in process
    func retrieveUserID(accessToken: String) async throws-> spotifyUserID {
        //define base endpoint
        let endpoint = "https://api.spotify.com/v1/me"
        //before passing it convert to URL object, can not be string; if fails throw error
        guard let url = URL(string: endpoint) else {
            throw spotifyErrorDetails.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        //recieve the response and the data
        let (data,response) = try await URLSession.shared.data(for: request)
        //ensure to get a successful response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw spotifyErrorDetails.invalidresponse
        }
        do {
            let decoder = JSONDecoder()
            //will take the received data from call and convert it to defined type of defined struct
            return try decoder.decode(spotifyUserID.self, from:data)
        } catch {
            //if could not do the above means could not convert to our defined struct
            throw spotifyErrorDetails.decodingFailed
        }
            
    }
    // MARK: - Playlist Creation
    //second step is to create a playlist using the userID and the title of the dream from the passed dream
    //requires the title of the dream, userID(already fetched)
    /// -Returns: an instnace of creaetePlaylistResponse, assuming user has never created a playlist for the current dream
    func createPlaylist(for dream: Dream, accessToken:String) async throws-> createPlaylistResponse{
        //make sure to have userID, else ensure stop
        guard let userID = currentUserID else {
            print("User ID is not available. Try again later.")
            throw spotifyErrorDetails.invalidresponse
        }
        
        //endpoint using userID
        let endpoint = "https://api.spotify.com/v1/users/\(userID)/playlists"
        //ensure its a url object
        guard let url = URL(string: endpoint) else {
            throw spotifyErrorDetails.invalidURL
        }
        //define is a POST request to ensure sending of body
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //instantiate json object with current dream information
        let playlistRequest = createPlaylistRequestBody(
            name: dream.title,
            description: ""
        )
        
        request.httpBody = try JSONEncoder().encode(playlistRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        //success error on spotify documentation is 200 not 201 NOTE TO SELF
        guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 201 else {
            throw spotifyErrorDetails.invalidresponse
        }
        
        print("📡 Playlist creation response status code: \(httpResponse.statusCode)")
        return try JSONDecoder().decode(createPlaylistResponse.self, from: data)
    }
}
