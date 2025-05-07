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
// MARK: -Pertain to playlist creation and fetching details from it

//holds information at creation of playlist/ first
struct createPlaylistResponse:Codable{
    let id:String //id of the playlist so can fetch
    let name: String
}
//struct to retrieve information of the playlist after all songs have been added to the playlist
struct playlistInformation:Codable{
    let images:[playlistImages] //array of object images defined in seperate struct called playlistImage
    let tracks:completedPlaylistInformation //holds metadata and further specifics of tracks contined
}
//useda after creation in conjucntion with struct above(only information reagridinf the images)
 struct playlistImages:Codable{
    let url:String
    let height:Int?
    let width:Int?
}
//after creation and finsihed adding all tracks to the playlist
struct completedPlaylistInformation:Codable{
    let total:Int //to know how many tracks held in the playlist can help during iteration
    let items:[playlistSongsItem] //items is an array of playlistsongitemswhich is then an object of tracks contianing more minute details of those tracks
}

//holds the actual information of individual songs in the playlist
struct playlistSongsItem:Codable{
    let track:specificTrackInformation
}
struct specificTrackInformation:Codable{
    let artists: [songArtist]  //array of the songs of the actual song
    let name: String    //name of song
    let id:String   //id of the ndividual song
}
//contains the names of the artists pertaining to each song
struct songArtist:Codable{
    let name:String
}

// MARK: -These structs pertain to search process of songs and the response
struct returnedTracks:Codable{
    let tracks: searchedItemsObject  //object of tracks
}

struct searchedItemsObject:Codable{
    let href:String
    let limit:Int
    let next:String?
    let offset:Int //documentation:The offset of the items returned (as set in the query or by default)
    let previous: String?
    let total:Int
    let items:[tracksObject]    //array of TrackObject
}

struct tracksObject:Codable{
    let id:String
    let name:String
    let uri:String
}
//MARK: -For debugging, define errors that folow error type

enum spotifyErrorDetails:Error{
    case invalidURL
    case invalidresponse
    case decodingFailed
}
// MARK: -These structs are to help facilate sending json object requests

struct createPlaylistRequestBody:Codable{
    let name:String
    let description:String  //will be empty string at instantiation, other boolean values have defualts, no need to define here
}

struct addTracksToPlaylistRequestBody:Codable{
    let uris:[String]   //array of all the track uris which are from the returned object from searchforsongs method
}
