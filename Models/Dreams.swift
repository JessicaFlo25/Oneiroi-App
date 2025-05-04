//
//  Dreams.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/19/25.
//

import Foundation
import SwiftData

@Model
final class Dream {
    @Attribute(.unique) var id: UUID//ensures no repeats
    var dreamDescription: String
    var title: String
    var date: Date
    var tags: [String] //will hold the tags frm gemini after dream is inserted and saved
    var playlistID: String? //this will hold the id of the created playlist to display in a different view
    var playlistWasCreated: Bool{playlistID != nil }
    //initializer
    init(description: String, title: String, date: Date = Date(), tags: [String] = [], playlistID: String? = nil) {
        self.id = UUID()
        self.dreamDescription = description
        self.title = title
        self.date = date
        self.tags = tags
        self.playlistID = playlistID
    }
}
