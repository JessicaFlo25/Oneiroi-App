//
//  ViewPlaylistViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 5/5/25.
//

import Foundation

class ViewPlaylistViewModel:ObservableObject {
    
    
    // MARK: -This function searches items
    ///Takes in access token and dream
    func f(for dream: Dream,accessToken:String) async throws -> returnedTracks {
        /// These are what we are going to pass to build our query
        //first grab the first tag(index 0) in tags array since this is the genre
        //ensure there are no special characters at this point again prbably should do another check,...
        let genreTag = dream.tags[0]
        let limit = 5
        let offset = 0
//        let type = ["track"]    //define type of item we are seacrhing for
        
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
}
