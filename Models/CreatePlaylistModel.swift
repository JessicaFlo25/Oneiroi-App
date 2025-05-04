//
//  CreatePlaylistModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/28/25.
//

import Foundation
//stores necesary structs thta hold responses from spotofy
//methods that play a role in creating a playlist 


//With structs defined below need to pay attention to matching keys of response
//first need to define struct to retrieve and hold the userID to proceed to make playlist etc.
struct spotifyUserID:Codable{
    let id:String
}

//for debugging, define errors that folow error type
enum spotifyErrorDetails:Error{
    case invalidURL
    case invalidresponse
    case decodingFailed
}
