//
//  CreatePlaylistViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/27/25.
//

import Foundation
import SwiftUICore
//will hold logic pertaining to calling methods within this view
//but rely on defined structs from spotify api defined in createplaylistmodel to hold responses
//
class CreatePlaylistViewModel:ObservableObject {
    @Published var isLoading: Bool = false
    @Published var currentUserID: String? //for debuggin purposes
    
    //responsible for grabbing the user ID from provuded endpoint
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
    
    // Mock version of createPlaylist
    func createPlaylist(for dream: Dream){
        print("the playlist is being created...")
    }
}
